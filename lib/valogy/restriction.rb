module Valogy
  class Restriction

    attr_accessor :property, :entity, :additional_restriction, :count, :column
    attr_accessor :constraint_name

    def generate_function_name(constraint_type, column, table)
      "valogy_check_#{constraint_type}_#{column}_on_#{table}"
    end
  end
end
