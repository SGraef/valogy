class Sheet < Valogy::BaseModel
  belongs_to :user
  has_many :slots
end
