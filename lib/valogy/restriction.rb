module Valogy
  class Restriction

    attr_accessor :property, :entity, :additional_restriction, :count, :column
    attr_accessor :constraint_name, :has_and_belongs_to_many, :constraint_suffix
    attr_accessor :operator

    def generate_function_name(constraint_type, column, table)
      "valogy_check_#{constraint_type}_#{column}_on_#{table}"
    end

    def generate_constraint_name(table_name)
      "valogy_#{table_name}_#{column}_#{constraint_suffix}"
    end

    def generate_function(column, count, other_table, function_name)
      entity.corresponding_model.connection.execute("CREATE OR REPLACE FUNCTION #{function_name}(object_id integer)
      RETURNS boolean AS
      $$
      BEGIN
      return ((SELECT COUNT(#{other_table}.#{column}) FROM #{other_table} WHERE #{column} = $1) #{self.operator} #{count} OR (SELECT CASE #{self.entity.corresponding_model.table_name}.consistent WHEN true THEN true ELSE false END FROM #{self.entity.corresponding_model.table_name} WHERE id = $1));
      END
      $$ LANGUAGE 'plpgsql';")
    end


    def generate_has_and_belongs_to_many
      classes = [Object.const_get(property.field.capitalize).table_name, entity.corresponding_model.table_name].sort
      join_table_name = "#{classes.first}_#{classes.last}"
      function_name = generate_function_name(
                      "has_and_belongs_to_many_#{self.constraint_suffix}",
                      "#{column}_#{entity}",
                      join_table_name
                      )
      entity.corresponding_model.connection.execute("CREATE OR REPLACE FUNCTION #{function_name}(object_id integer, foreign_object_id integer)
      RETURNS boolean AS
      $$
      BEGIN
      return ((SELECT COUNT(#{join_table_name}.#{column}) FROM #{join_table_name} WHERE #{column} = $1) #{self.operator} #{count} OR (SELECT CASE #{self.entity.corresponding_model.table_name}.consistent WHEN true THEN true ELSE false END FROM #{self.entity.corresponding_model.table_name} WHERE id = $1));
      END
      $$ LANGUAGE 'plpgsql';")
    end
  end
end
