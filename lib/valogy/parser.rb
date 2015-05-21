module Valogy
  class Parser
    EXACTLY  = "qualifiedCardinality"
    PROPERTY = "onProperty"
    MINIMAL  = "minQualifiedCardinality"
    EXISTENCE= "someValuesFrom"
    LANGUAGES= ["de","en", "fr", "es"]
    attr_accessor :constraints, :inverse_constraints, :classes, :entities
    attr_accessor :axioms, :validation_hash

    def open_file(file_path)
      file = File.open(file_path)
      @ontology = Nokogiri::XML(file) do |config|
        config.noblanks
      end
    end

    def self.parse(file)
      parser = self.new
      parser.open_file(file)
      parser.constraints = Hash.new
      parser.inverse_constraints = Hash.new
      parser.entities = Hash.new
      parser.axioms = Hash.new
      parser.validation_hash = Hash.new
      LANGUAGES.each do |lang|
        parser.validation_hash[lang] = {"valogy" => {"model" => Hash.new}}
      end
      parser.all_constraints
      parser.all_axioms
      parser.all_classes
      File.open("#{Rails.root}/config/locales/valogy.yml", 'w') {|f| f.write parser.validation_hash.to_yaml }

    end

    def all_constraints
      data_props = @ontology.xpath("//owl:DatatypeProperty")
      data_props.each do |data|
        prop = DataProperty.new
        name_with_iri = data.attributes["about"].value
        prop.name = name_with_iri.split("#").last
        data.children.each do |sub|
          case sub.name
          when "range"
            datatype_with_iri = sub.attributes["resource"].value
            prop.datatype = datatype_with_iri.split("#").last
            break
          when "label"
            prop.column = sub.children.to_s
            break
          end
        end
        self.constraints[prop.name.to_sym] = prop
      end
      obj_props = @ontology.xpath("//owl:ObjectProperty")
      obj_props.each do |obj|
        prop = ObjectProperty.new
        name_with_iri = obj.attributes["about"].value
        name = name_with_iri.split("#").last
        prop.name = name
        obj.children.each do |sub|
          case sub.name
          when "domain"
            field_with_iri = sub.attributes["resource"].value
            prop.object = field_with_iri.split("#").last
          when "range"
            range_with_iri = sub.attributes["resource"].value
            prop.field = range_with_iri.split("#").last.downcase
          when "inverseOf"
            inverse_with_iri = sub.attributes["resource"].value
            name_of_inverse = inverse_with_iri.split("#").last
            prop.inverse = self.constraints[name_of_inverse.to_sym] || name_of_inverse
          when "comment"
            comment = Comment.new
            comment.text = sub.children.text
            comment.lang = sub.attributes["lang"].value
            prop.add_comment(comment)
          end
        end
        if prop.inverse
          if prop.inverse.class == String
            self.inverse_constraints[prop.inverse.to_sym] = prop
          else
            self.inverse_constraints[prop.inverse.name.to_sym] = prop
          end
        elsif self.inverse_constraints.has_key?(name.to_sym)
          inverse = self.inverse_constraints[name.to_sym]
          prop.inverse = inverse
          prop.inverse.inverse = prop
        end
        self.constraints[name.to_sym] = prop
      end
    end

    def all_axioms
      axioms = @ontology.xpath("//owl:Axiom")
      axioms.each do |axiom|
        ax = Axiom.new
        axiom.children.each do |sub|
          case sub.name
          when "annotatedSource"
            ax.corresponding_model = Object.const_get(extract_qualified_name(sub.attributes["resource"].value))
          when "annotatedProperty"

          when "annotatedTarget"
            constraint_with_iri = sub.children.first.children.
                                  first.attributes["resource"].value
            ax.constraint =
            constraints[extract_qualified_name(constraint_with_iri).to_sym]
          else
            ax.name = sub.name
            ax.additional_information = sub.children.first.to_s
          end
        end
        self.axioms[ax.name.to_sym] = ax
      end
    end

    def all_classes
      classes = @ontology.xpath("//owl:Class")
      classes.each do |klass|
        modelname = extract_qualified_name(klass.attributes["about"].value)
        @model = determine_model(klass)
        entity = Entity.new(@model)
        entities[modelname.to_sym] = entity
        build_restrictions(restrictions(klass), entity)
        resolve_restriction(entity)
        #  restrictions(klass).each { |restriction| resolverestriction(restriction) }
      end

    end

    def determine_model(element)
      klass = extract_qualified_name(element.attributes["about"].value)
      Object.const_get(klass)
    end

    def determine_column(element)
      property_name = extract_qualified_name(element.attributes["resource"].value)
      constraint = self.constraints[property_name.to_sym]
      if constraint.class == ObjectProperty
        column_name = constraint.field || property_name.sub("has","").downcase
        if property_name.include?("belongsTo")
          column_name = column_name + "_id"
        end
      elsif constraint.class == DataProperty
        column_name = constraint.column || property_name.sub("has","").downcase
        constraint.column = column_name unless constraint.column
      end
      return column_name
    end

    def extract_qualified_name(value)
      value.split("#").last
    end

    def restrictions(element)
      element.xpath(".//owl:Restriction")
    end

    def build_restrictions(restrictions, entity)
      restrictions.each do |restriction|
        restriction.children.each do |constr|
          case constr.name
          when PROPERTY
            @column = determine_column(constr)
            @constraint_name = extract_qualified_name(constr.attributes["resource"].value)

          when EXACTLY
            count = constr.child.text.to_i
            restrict = ExactlyRestriction.new
            property = self.constraints[@constraint_name.to_sym]
            column = entity.corresponding_model.name.downcase + "_id"
              if property.name.include?("belongsTo")
                restrict = ExistenceRestriction.new
                restrict.entity = entity
                restrict.column = property.field + "_id"
                restrict.property= property
                entity.add_restriction(restrict)
              else
                foreign_table = Object.const_get(property.field.capitalize).table_name
                restrict.entity = entity
                restrict.foreign_table = foreign_table
                #TODO Better column Detection
                restrict.column = column
                count = constr.child.text.to_i
                restrict.count = count
                restrict.property= property
                entity.add_restriction(restrict)
              end
          when MINIMAL
            restrict = MinimalRestriction.new
            foreign_table = Object.const_get(self.constraints[@constraint_name.to_sym].field.capitalize).table_name
            restrict.entity = entity
            restrict.foreign_table = foreign_table
            #TODO Better column Detection
            restrict.column = entity.corresponding_model.name.downcase + "_id"
            count = constr.child.text.to_i
            restrict.count = count
            restrict.property= self.constraints[@constraint_name.to_sym]
            entity.add_restriction(restrict)
          when EXISTENCE
            property = self.constraints[@constraint_name.to_sym]
            if property.class == DataProperty
              restrict = ExistenceRestriction.new
              restrict.entity = entity
              restrict.column = @column
              restrict.property= self.constraints[@constraint_name.to_sym]
              entity.add_restriction(restrict)
            elsif property.class == ObjectProperty
              restrict = MinimalRestriction.new
              foreign_table = Object.const_get(self.constraints[@constraint_name.to_sym].field.capitalize).table_name
              restrict.entity = entity
              restrict.foreign_table = foreign_table
              #TODO Better column Detection
              restrict.column = entity.corresponding_model.name.downcase + "_id"
              restrict.count = 1
              restrict.property= self.constraints[@constraint_name.to_sym]
              entity.add_restriction(restrict)
            end
          end
        end
      end
    end

    def resolve_restriction(entity)
      entity.restrictions.each do |restriction|
      restriction.resolve
      name = restriction.constraint_name
      property = restriction.property
      property.comments.each do |comment|
        validation_hash[comment.lang]['valogy'][name] = comment.text
        validation_hash[comment.lang]['valogy']['model'][name] = restriction.column
      end
      end
    end
=begin
%old
    def resolverestriction(restriction)
      restriction.children.each do |constr|
        case constr.name
        when PROPERTY
          @column = determine_column(constr)
          @constraint_name = extract_qualified_name(constr.attributes["resource"].value)
        when EXACTLY
          count = constr.child.text.to_i
          if @column
            if count == 1
              @model.new.existence(@column)
            end
          end
          break
        when MINIMAL
          foreign_table = Object.const_get(self.inverse_constraints[@constraint_name.to_sym].field.capitalize).table_name
          count = constr.child.text.to_i
          if @column
            @model.new.minimal(@column, count, foreign_table)
          end
        end
      end
    end
=end
  end
end
