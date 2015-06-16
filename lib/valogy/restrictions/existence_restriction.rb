module Valogy
  class ExistenceRestriction < Valogy::Restriction

    def resolve
      if property.class == DataProperty
        existence
      elsif property.class == ObjectProperty
        existence_between_models
      end
    end

    def initialize
      self.constraint_suffix = "not_null"
    end

    def existence
      self.constraint_name = generate_constraint_name(entity.corresponding_model.table_name)
    entity.corresponding_model.connection.execute("ALTER TABLE #{entity.corresponding_model.table_name} ADD CONSTRAINT
    #{self.constraint_name} CHECK (#{column} IS NOT NULL)")
    end

    def existence_between_models
        self.constraint_name = generate_constraint_name(entity.corresponding_model.table_name)
        entity.corresponding_model.connection.execute("ALTER TABLE #{entity.corresponding_model.table_name} ADD CONSTRAINT
        #{self.constraint_name} CHECK (#{column} IS NOT NULL)")
    end

  end
end
