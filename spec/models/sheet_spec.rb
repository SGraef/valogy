require 'rails_helper'

RSpec.describe Sheet, :type => :model do

  let(:user)  {User.create!(username: "foobar", password: "123456")}
  let(:sheet) {Sheet.new(user: user)}


  context "generating a sheet" do
    it "should raise an error for an sheet without an slot" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect{sheet.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should raise no error for an sheet with an slot" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      sheet = Sheet.new(user: user, slots: [Slot.new], consistent: false)
      expect{sheet.save!}.not_to raise_error
    end
  end
end
