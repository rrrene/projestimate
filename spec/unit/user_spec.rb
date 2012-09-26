require 'spec_helper'

describe User do
  it "should be valid" do
    user = build(:user)
    user.valid?.should be_false
  end

  it "should be have Nom Prenom" do
    user = build(:user)
    user.name.should eq("Renard Nicolas")
  end

  it "should be an admin if he had admin right" do
  #TODO
  end
end