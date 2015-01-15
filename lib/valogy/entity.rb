class Entity

  attr_accessor :corresponding_model, :restrictions, :fields

  def initialize(c_model)
    self.corresponding_model = c_model
    self.restrictions = []
    self.fields = []
  end

  def add_restriction(restriction)
    restrictions << restriction
  end

  def add_field(field)
    fields << field
  end

end
