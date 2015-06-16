module Valogy
  class ExactlyRestriction < Valogy::Restriction

    attr_accessor :foreign_table

    def initialize
      self.constraint_suffix = "exactly"
      self.operator = "="
    end

    def resolve
      if has_and_belongs_to_many
        generate_excatly_has_and_belongs_to_many
      else
        function_name  = generate_function_name("exactly_occurence_#{count}",   column, foreign_table)
        generate_function(column, count, foreign_table, function_name)
        self.constraint_name = generate_constraint_name
        entity.corresponding_model.connection.execute("ALTER TABLE  #{self.entity.corresponding_model.table_name} ADD CONSTRAINT
        #{self.constraint_name} CHECK (#{function_name}(id))")
      end
    end
  end
end
