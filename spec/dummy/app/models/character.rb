class Character < Valogy::BaseModel
  has_and_belongs_to_many :items
end
