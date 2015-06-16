module Valogy
  class Maximal_Restriction < Valogy::Restriction

    def initialize
      self.constraint_suffix = "maximal"
      self.operator = "<="
    end

    def resolve
      if has_and_belongs_to_many
        classes = [Object.const_get(property.field.capitalize).table_name, entity.corresponding_model.table_name].sort
        join_table_name = "#{classes.first}_#{classes.last}"
        function_name = generate_function_name(
                        "has_and_belongs_to_many_#{self.constraint_suffix}",
                        "#{column}_#{entity}",
                        join_table_name
                        )
        generate_function(column, count, join_table_name, function_name)
      else
        function_name  = generate_function_name("maximal_occurence", column, foreign_table)
        generate_function(column, count, foreign_table, function_name)
      end
      self.constraint_name = generate_constraint_name(foreign_table)
      entity.corresponding_model.connection.execute("ALTER TABLE
      #{self.entity.corresponding_model.table_name} ADD CONSTRAINT
      #{self.constraint_name} CHECK (#{function_name}(id))")
    end

  end
end
