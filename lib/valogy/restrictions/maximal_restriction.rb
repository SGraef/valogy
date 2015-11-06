module Valogy
  class Maximal_Restriction < Valogy::Restriction

    attr_accessor :foreign_table

    def initialize
      self.constraint_suffix = "maximal"
      self.operator = "<="
    end
  end
end
