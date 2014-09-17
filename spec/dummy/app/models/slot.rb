class Slot < ActiveRecord::Base
  include Valogy::Query

  belongs_to :sheet
end
