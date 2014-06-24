module Valogy
  class Parser
    EXACTLY  = "qualifiedCardinality"
    PROPERTY = "onProperty"
    
    def open_file(file_path)
      file = File.open(file_path)
      @ontology = Nokogiri::XML(file) do |config|
        config.noblanks
      end
    end
      
    def self.parse(file)
      parser = self.new
      parser.open_file(file)
      parser.all_classes
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
      extract_qualified_name(element.attributes["resource"].value).sub("has","").downcase
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
