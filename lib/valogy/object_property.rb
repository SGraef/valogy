module Valogy
  class ObjectProperty
    attr_accessor :field, :name, :object, :inverse

    def initialize(name, object, field, inverse)
      self.name = name
      self.object = object
      self.field = field
      self.inverse = inverse
    end

    def initialize
    end

  end
end
