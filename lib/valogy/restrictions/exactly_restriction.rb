module Valogy
  class ExactlyRestriction < Valogy::Restriction

    attr_accessor :foreign_table

    def initialize
      self.constraint_suffix = "exactly"
      self.operator = "="
    end

  end
end
