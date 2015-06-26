require 'rails_helper'

RSpec.describe Character, :type => :model do
  let(:character)  {Character.new}
  let(:item) {Item.new}


  context "generating a character" do
    it "should raise an error for an character without an item" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect{character.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should raise no error for an sheet with an slot" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      char = Character.new(items: [Item.new,Item.new])
      expect{char.save!}.not_to raise_error
    end
  end
end
