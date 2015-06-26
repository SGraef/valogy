module Valogy
  class Maximal_Restriction < Valogy::Restriction

    def initialize
      self.constraint_suffix = "maximal"
      self.operator = "<="
    end
  end
end
