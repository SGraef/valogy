module Valogy
  class DataProperty
    attr_accessor :label, :name, :datatype

    def initialize(name, datatype, label)
      self.name = name
      self.datatype = datatype
      self.label = label
    end
  end
end
