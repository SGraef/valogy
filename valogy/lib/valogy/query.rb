module Valogy
  module Query
   def existence(table, column)
     result = execute("ALTER TABLE #{table} ALTER COLUMN #{column} SET NOT NULL;")
   end 
   
   def existence_between_models(table, index, constraint)
     result = execute("ALTER TABLE #{table} ADD CONSTRAINT #{constraint} PRIMARY KEY USING INDEX dist_id_temp_idx;")
   end
   
  end
end