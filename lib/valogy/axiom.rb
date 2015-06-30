module Valogy
  class Axiom
    attr_accessor :constraint, :corresponding_model, :name
    attr_accessor :additional_information, :datatype

    def resolve
      constraint_name = generate_constraint_name(corresponding_model.table_name)
    corresponding_model.connection.execute("ALTER TABLE #{corresponding_model.table_name} ADD CONSTRAINT #{constraint_name} CHECK (#{constraint.column} #{"SIMILAR TO" if datatype=="string"} '#{additional_information}')")
    end

    def generate_constraint_name(table_name)
      "valogy_#{table_name}_#{constraint.column}_data_validation"
    end
  end
end
