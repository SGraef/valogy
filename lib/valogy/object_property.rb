module Valogy
  class ObjectProperty
    attr_accessor :label, :name, :field, :name_of_inverse

    def initialize(name, field, label, name_of_inverse)
      self.name = name
      self.field = field
      self.label = label
      self.name_of_inverse = name_of_inverse
    end
  end
end
