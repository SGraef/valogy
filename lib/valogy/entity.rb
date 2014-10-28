class Entity

  attr_accessor :corresponding_model, :restrictions

  def initialize(model)
    corresponding_model = model
    restrictions = []
  end

  def add_restriction(restricion)
    restrictions << restriction
  end
  
end
