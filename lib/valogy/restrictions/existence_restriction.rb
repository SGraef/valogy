module Valogy
  class ExistenceRestriction < Valogy::Restriction

    def resolve
      self.constraint_name = generate_constraint_name(entity.corresponding_model.table_name)
    entity.corresponding_model.connection.execute("ALTER TABLE #{entity.corresponding_model.table_name} ADD CONSTRAINT
    #{self.constraint_name} CHECK (#{column} IS NOT NULL)")
    end

    def initialize
      self.constraint_suffix = "not_null"
    end

  end
end
