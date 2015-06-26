class Item < Valogy::BaseModel
  has_and_belongs_to_many :characters
end
