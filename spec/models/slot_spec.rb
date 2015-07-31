require 'rails_helper'

RSpec.describe Slot, :type => :model do
  let(:instance) do
    Slot.new
  end

  context "constraints which is for attributes of the model" do
    it "raise an error if not fullfilled constraints" do
      Valogy::Translator.parse("#{fixture_path}/test.owl")
      expect {Slot.create!}.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "raise no error if fullfilled constraints" do
      Valogy::Translator.parse("#{fixture_path}/test.owl")
      expect {Slot.create!(sheet_id: 1)}.not_to raise_error
    end
  end
end
