require "spec_helper"

describe PbsProjectElement do

  before :each do
    @work_element_type = FactoryGirl.build(:work_element_type, :wet_folder)
    @folder = FactoryGirl.create(:folder)   # Pbs_project_element
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

  it "should duplicate pbs project element" do
    @folder2=@folder.amoeba_dup
    @folder2.copy_id = @folder.id
  end

end
