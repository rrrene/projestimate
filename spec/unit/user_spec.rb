require "spec_helper"

describe User do

  before :each do
    @admin =  User.first
  end

  it "should be valid" do
    @admin.should be_valid
  end

  it "should be have Nom Prenom" do
    @admin.name.should eq("Administrator Projestimate")
  end

  it "should return groups array (globals permissions)" do
  end

  it "should return groups array (specific permissions)" do
  end

  it "should be authenticate by the application" do
  end

  it "should be authenticate by the a LDAP directory" do
  end

  it "should be an admin if he had admin right" do
  end

  it "should be delete recent projects" do
  end

  it "should be add recent projects" do
  end

  it "should return a search result (using for datatables plugins)" do
  end

end