module Valogy
  class BaseModel < ActiveRecord::Base
    include Valogy::Query
  end
end
