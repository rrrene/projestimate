require 'spec_helper'

describe WbsProjectElement do
  before :each do
    @project = FactoryGirl.create(:project)
    @pe_wbs_project = FactoryGirl.create(:pe_wbs_project, :project => @project)
    @wbs_project_element = FactoryGirl.create(:wbs_project_element, :pe_wbs_project => @pe_wbs_project)
  end

  it "should be valid" do
    @wbs_project_element.should be_valid
  end

  it "should not be valid without name" do
    @wbs_project_element.name = ""
    @wbs_project_element.should_not be_valid
  end
end
