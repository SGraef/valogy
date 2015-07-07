require 'rails_helper'

RSpec.describe Valogy::Parser do

context "constraints which is for attributes of the model" do
    context "constraint generation" do
      it "raise no error" do
        expect(Valogy::BaseModel.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_users_username_not_null' ").ntuples).to eq(0)
        expect(Valogy::BaseModel.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_slots_sheet_id_minmal' ").ntuples).to eq(0)
        expect{Valogy::Parser.parse("#{fixture_path}/test.owl")}.not_to raise_error
        expect(Valogy::BaseModel.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_slots_sheet_id_minimal' ").ntuples).to eq(1)
        expect(Valogy::BaseModel.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_users_username_not_null' ").ntuples).to eq(1)
      end
    end
  end
end
