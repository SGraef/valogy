class Sheet < Valogy::BaseModel
  belongs_to :user
  has_many :slots

	attr_accessor :generate_slots
end
