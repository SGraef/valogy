module Valogy
  class MinimalRestriction < Valogy::Restriction

    attr_accessor :foreign_table

    def initialize
      self.constraint_suffix = "minimal"
      self.operator = ">="
    end

  end
end
