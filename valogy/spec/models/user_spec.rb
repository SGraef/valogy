require 'rails_helper'

RSpec.describe User, :type => :model do
    
  let(:instance) do
    class User
      include Valogy::Query
    end
    User.new
  end
  
  context "constraints which is for attributes of the model" do
    context "generation" do
      it "raise no error" do
        expect {instance.existence("users", "username")}.not_to raise_error
      end
    end
    it "raise an error if not fullfilled constraints" do
      instance.existence("users", "username")
      expect {User.create!}.to raise_error
    end
  end
end
