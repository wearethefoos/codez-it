require 'spec_helper'

describe Account do
  describe "#new" do
    it "should validate presence and uniqueness of the account name." do
      Account.new(name: "").should be_invalid

      Account.new(name: "FooBar").save
      Account.new(name: "FooBar").should be_invalid
    end
  end
end
