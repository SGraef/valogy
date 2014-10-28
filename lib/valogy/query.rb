module Valogy
  module Query
   def existence(column)
     self.class.connection.execute("ALTER TABLE #{self.class.table_name} ADD CONSTRAINT
      valogy_#{self.class.table_name}_#{column}_not_null CHECK (#{column} IS NOT NULL)")
   end

   def existence_between_models(column)
    self.class.connection.execute("ALTER TABLE #{self.class.table_name} ADD CONSTRAINT
     valogy_#{self.class.table_name}_#{column}_not_null (#{column} IS NOT NULL)")
   end

   def minimal(column, count, other_table)
    function_name  = generate_function_name("minimal_occurence", column, self.class.table_name)
     generate_minimal_function(column, count, other_table, function_name)
     self.class.connection.execute("ALTER TABLE #{self.class.table_name} ADD CONSTRAINT
      valogy_#{self.class.table_name}_#{column}_minimal CHECK (#{function_name}(#{column}))")
   end

   def generate_minimal_function(column, count, other_table, function_name)
     self.class.connection.execute("CREATE OR REPLACE FUNCTION #{function_name}(object_id integer)
     RETURNS boolean AS
     $$
      BEGIN
        IF (SELECT COUNT(*) FROM #{other_table} WHERE #{column} = $1) > #{count -1} THEN return true; ELSE return false;
        END IF;
      END
     $$ LANGUAGE 'plpgsql';")
   end

   def generate_function_name(constraint_type, column, table)
     "valogy_check_#{constraint_type}_#{column}_on_#{table}"
   end

  end
end
