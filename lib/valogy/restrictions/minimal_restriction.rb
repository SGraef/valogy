module Valogy
  class MinimalRestriction < Valogy::Restriction

    attr_accessor :foreign_table

    def resolve
      function_name  = generate_function_name("minimal_occurence", column, foreign_table)
      generate_minimal_function(column, count, foreign_table, function_name)
      entity.corresponding_model.connection.execute("ALTER TABLE #{self.entity.corresponding_model.table_name} ADD CONSTRAINT
      valogy_#{foreign_table}_#{column}_minimal CHECK (#{function_name}(id))")
    end

    def generate_minimal_function(column, count, other_table, function_name)
      entity.corresponding_model.connection.execute("CREATE OR REPLACE FUNCTION #{function_name}(object_id integer)
      RETURNS boolean AS
      $$
      BEGIN
      return ((SELECT COUNT(#{other_table}.#{column}) FROM #{other_table} WHERE #{column} = $1) >= #{count} OR (SELECT CASE #{self.entity.corresponding_model.table_name}.consistent WHEN true THEN true ELSE false END FROM #{self.entity.corresponding_model.table_name} WHERE id = $1));
      END
      $$ LANGUAGE 'plpgsql';")
    end

  end
end
