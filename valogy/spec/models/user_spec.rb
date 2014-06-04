require 'rails_helper'

RSpec.describe User, :type => :model do
    
  let(:instance) do
    class Klass
      include Valogy::Query
    end
    Klass.new
  end
  
  context "constraints which is for attributes of the model" do
    context "generation" do
      it "raise no error" do
        expect {instance.existence("user", "username")}.not_to raise_error
      end
    end
    it "raise an error if not fullfilled constraints" do
      expect {User.create!}.to raise_error
    end
  end
end
