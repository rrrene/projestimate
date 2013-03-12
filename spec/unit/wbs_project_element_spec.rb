require 'spec_helper'

describe WbsProjectElement do
  before :each do
    @project = FactoryGirl.create(:project)
    @pe_wbs_project = FactoryGirl.create(:pe_wbs_project, :wbs_type => "Activity", :project => @project)
    @wbs_project_element = FactoryGirl.create(:wbs_project_element, :is_root => true, :pe_wbs_project => @pe_wbs_project)
  end

  it "should be valid" do
    @wbs_project_element.should be_valid
  end

  it "should not be valid without name" do
    @wbs_project_element.name = ""
    @wbs_project_element.should_not be_valid
  end

  it "should not be from Library" do
    @wbs_project_element.is_from_library_and_is_leaf?.should be_false
  end

  it "Duplicate project element" do
    @wbs_project_element2=@wbs_project_element.amoeba_dup
  end
end
