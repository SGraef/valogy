module Valogy
  module Query
   include ActiveRecord::Base
   @connection = ActiveRecord::Base.connection
   def existence(table, column)
     result = @connection.exectue("ALTER TABLE #{table} ALTER COLUMN #{column} SET NOT NULL;")
   end 
   
   def existence_between_models(table, index, constraint)
     result = @connection.execute("ALTER TABLE #{table} ADD CONSTRAINT #{constraint} PRIMARY KEY USING INDEX dist_id_temp_idx;")
   end
   
  end
end