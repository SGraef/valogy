require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:instance) do
    User.new
  end

  context "constraints which is for attributes of the model" do
    it "raise an error if not fullfilled constraints" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect {User.create!}.to raise_error
    end
    it "raise no error if fullfilled constraints" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect {User.create!(username: "foobar", password: "12345", email: "foo@bar.de")}.not_to raise_error
    end
    it "raise an error if data is not valid" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect{User.create!(username: "foobar", password:"12345", email:"bla")}.to raise_error
    end
    it "raise no if data is valid" do
      Valogy::Parser.parse("#{fixture_path}/test.owl")
      expect{User.create!(username: "foobar", password:"12345", email:"foo@bar.de")}.not_to raise_error
    end
  end
end
