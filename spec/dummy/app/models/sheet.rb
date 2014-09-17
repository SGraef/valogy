class Sheet < ActiveRecord::Base
  include Valogy::Query

  has_many :slots
end
