module Valogy
  class ExactlyRestriction < Valogy::Restriction

    def resolve
      if property.class == DataProperty
        existence
      elsif property.class == ObjectProperty
        existence_between_models
      end
    end

    def existence
    entity.corresponding_model.connection.execute("ALTER TABLE #{entity.corresponding_model.table_name} ADD CONSTRAINT
    valogy_#{entity.corresponding_model.table_name}_#{column}_not_null CHECK (#{column} IS NOT NULL)")
    end

    def existence_between_models

    end

  end
end
