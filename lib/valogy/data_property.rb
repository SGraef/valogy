module Valogy
  class DataProperty
    attr_accessor :column, :name, :datatype, :axioms

    def initialize(name, datatype, column)
      self.name = name
      self.datatype = datatype
      self.column = column
    end

    def initialize()

    end

    def axioms
      @axioms || {}
    end

  end
end
