require 'rails_helper'

RSpec.describe Slot, :type => :model do
  let(:instance) do
    Slot.new
  end

  context "constraints which is for attributes of the model" do
    context "generation" do
      it "raise no error" do
        expect(instance.class.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_slots_sheet_id_not_null' ").ntuples).to eq(0)
        expect{Valogy::Parser.parse("#{fixture_path}/test.owl")}.not_to raise_error
        expect(instance.class.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_slots_sheet_id_not_null' ").ntuples).to eq(1)
      end
    end
    it "raise an error if not fullfilled constraints" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect {Slot.create!}.to raise_error
    end
    it "raise an error if fullfilled constraints" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect {Slot.create!(sheet_id: 1)}.not_to raise_error
    end
  end
end
