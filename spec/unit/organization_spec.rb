require "spec_helper"

describe Organization do
  before :each do
    @organization = Organization.first
  end

  it "should be valid" do
    @organization.should be_valid
  end

  it "should not be valid without name" do
    @organization.name = ""
    @organization.should_not be_valid
  end

  it "should return :organization name" do
    @organization.to_s.should eql(@organization.name)
  end
end