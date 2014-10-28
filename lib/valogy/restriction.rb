class Restriction

  attr_accessor :property, :entity, :additional_restriction

  def initialize(property, entitiy, restriction)
    self.property = property
    self.entity = entity
    additional_restriction = restriction
  end

end
