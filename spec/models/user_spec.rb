require 'rails_helper'

RSpec.describe User, :type => :model do
    
  let(:instance) do
    User.new
  end
  
  context "constraints which is for attributes of the model" do
    context "generation" do
      it "raise no error" do
        expect (instance.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_users_username_not_null' ").ntuples).should  eq(0)
        expect {Valogy::Parser.parse("../fixtures/werwolf-xml.owl")}.not_to raise_error
        expect (instance.connection.execute("SELECT * FROM pg_constraint WHERE conname='valogy_users_username_not_null' ").ntuples).should eq(1)
      end
    end
    it "raise an error if not fullfilled constraints" do
      Valogy::Parser.parse("../fixtures/werwolf-xml.owl")
      expect {User.create!}.to raise_error
    end
  end
end