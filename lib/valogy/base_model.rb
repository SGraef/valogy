module Valogy
  class BaseModel < ActiveRecord::Base
    @abstract_class = true
    after_save :set_consistency, unless: :consistent?
    include Valogy::Query

    def set_consistency
      self.consistent = true
      self.save!
      puts "====================#{self.class}=============="
      puts "====================#{self.try(:slots).inspect}=============="
      puts "====================#{self.inspect}=============="
    end

    def consistent?
      self.consistent
    end

  end
end
