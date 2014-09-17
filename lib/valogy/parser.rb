module Valogy
  class Parser
    EXACTLY  = "qualifiedCardinality"
    PROPERTY = "onProperty"

    attr_accessor :constraints, :inverse_constraints

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
      parser.all_constraints
      parser.all_classes
    end

    def all_constraints
      data_props = @ontology.xpath("//owl:DatatypeProperty")
      data_props.each do |data|
        name_with_iri = data.attributes["about"].value
        name = name_with_iri.split("#").last
        data.children.each do |sub|
          case sub.name
          when "range"
            datatype_with_iri = sub.attributes["resource"].value
            @datatype = datatype_with_iri.split("#").last
            break
          when "label"
            @label = sub.children.to_s
            break
          end
        end
        prop = DataProperty.new(name, @datatype, @label)
        self.constraints[name.to_sym] = prop
      end
      obj_props = @ontology.xpath("//owl:ObjectProperty")
      obj_props.each do |obj|
        name_with_iri = obj.attributes["about"].value
        name = name_with_iri.split("#").last
        obj.children.each do |sub|
          case sub.name
          when "domain"
            field_with_iri = sub.attributes["resource"].value
            @field = field_with_iri.split("#").last
            break
          when "range"
            range_with_iri = sub.attributes["resource"].value
            @range = range_with_iri.split("#").last.downcase
            break
          when "inverseOf"
              inverse_with_iri = sub.attributes["resource"].value
              @inverse = inverse_with_iri.split("#").last
            break
          end
        end
        prop = ObjectProperty.new(name, @field, @range, @inverse)
        if @inverse
          self.constraints[@inverse.to_sym].name_of_inverse = name
          self.inverse_constraints[name.to_sym] = prop
        end
        self.constraints[name.to_sym] = prop
      end
    end

    def all_classes
      classes = @ontology.xpath("//owl:Class")
      classes.each do |c|
        @model = determine_model(c)
        restrictions(c).each { |restriction| resolverestriction(restriction) }
      end
    end

    def determine_model(element)
      klass = extract_qualified_name(element.attributes["about"].value)
      Object.const_get(klass)
    end

    def determine_column(element)
      property_name = extract_qualified_name(element.attributes["resource"].value)
      constraint = self.constraints[property_name.to_sym]
      column_name = constraint.label || property_name.sub("has","").downcase
      if property_name.include?("belongsTo")
        column_name = column_name + "_id"
      end
      return column_name
    end

    def extract_qualified_name(value)
      value.split("#").last
    end

    def restrictions(element)
      element.xpath(".//owl:Restriction")
    end

    def resolverestriction(restriction)
      restriction.children.each do |constr|
        case constr.name
        when PROPERTY
          @column = determine_column(constr)
        when EXACTLY
          count = constr.child.text.to_i
          if @column
            if count == 1
              @model.new.existence(@column)
            end
          end
        end
      end
    end

  end
end
