require "spec_helper"

describe PbsProjectElement do

  before :each do
    @work_element_type = FactoryGirl.build(:work_element_type, :wet_folder)
    @folder = FactoryGirl.create(:folder)
    @folder1 = FactoryGirl.create(:folder, :name => "Folder11", :work_element_type => @work_element_type)
    @bad = FactoryGirl.create(:bad, :name => "bad_name")
  end

  it 'should be valid' do
    @folder.should be_valid
  end

  it "should be not valid without name" do
    @bad.name = ""
    @bad.should_not be_valid
  end

  it "should return PBS Project element name" do
    @folder.to_s.should eql("Folder1")
  end

  it "should have a correct type" do
    @folder1.folder?.should be_true
  end

  it "should have return an array of value" do
    @folder.ksloc.should be_an_instance_of Array
  end

  it "should have return only one value" do
    @folder.ksloc_low.should be_empty
  end

end