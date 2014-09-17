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

  end
end
