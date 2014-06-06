module Valogy
  module Parsing
    EXACTLY  = "qualifiedCardinality"
    PROPERTY = "onProperty"
    
    def open_file(file_path)
      file = File.open(file_path)
      @ontology = Nokogiri::XML(file) do |config|
        config.noblanks
      end
      parse
    end
      
    def self.parse(file)
      open_file(file)
      all_classes
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
    
    def dermine_column(element)
      extract_qualified_name(element.attributes["resource"].value).downcase
    end
    
    def extract_qualified_class_name(value)
      value.split("#").last
    end
    
    def restriction(element)
      element.xpath(".//owl:Restrictions")
    end
    
    def resolverestriction(restriction)
      @column = nil
      restriction.children.each do |constr|
        case constr.name
        when PROPERTY
          @column = determine_column(constr)
        when EXACTLY
          count = constr.child.text
          if @column
            if count == 1
              @model.existance(@column)
            end
          end
        end
      end
    end
  end
end
