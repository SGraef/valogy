module Valogy
  class Maximal_Restriction < Valogy::Restriction

    def initialize
      self.constraint_suffix = "maximal"
      self.operator = "<="
    end

    def resolve
      function_name  = generate_function_name("maximal_occurence", column, foreign_table)
      if has_and_belongs_to_many
        generate_has_and_belongs_to_many
      else
        generate_function(column, count, foreign_table, function_name)
        self.constraint_name = generate_constraint_name(foreign_table)
        entity.corresponding_model.connection.execute("ALTER TABLE
        #{self.entity.corresponding_model.table_name} ADD CONSTRAINT
        #{self.constraint_name} CHECK (#{function_name}(id))")
      end
    end

  end
end
