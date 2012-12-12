require "spec_helper"

describe Component do

  before :each do
    @folder = FactoryGirl.build(:folder)
    @bad = FactoryGirl.build(:bad)
  end

  it 'should be valid' do
    @folder.should be_valid
  end

  it "should be not valid without name" do
    @bad.should_not be_valid
  end

  it "should return component name" do
    @folder.to_s.should eql("Folder1")
  end

  it "should have a correct type" do
    @folder.folder?.should be_true
  end

  it "should have return an array of value" do
    @folder.ksloc.should be_an_instance_of Array
  end

  it "should have return only one value" do
    @folder.ksloc_low.should be_empty
  end

end
