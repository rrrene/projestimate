require "spec_helper"

describe PeWbsProject do

  before :each do
    @project = FactoryGirl.create(:project)
    @pe_wbs_project = FactoryGirl.create(:pe_wbs_project, :project=> @project)
  end

  it "should duplicate pe_wbs_project" do
    @pe_wbs_project2=@pe_wbs_project.amoeba_dup
    @pe_wbs_project2.name = "PE-WBS Copy_#{ @pe_wbs_project2.project.copy_number.to_i+1} of #{@pe_wbs_project2.project.title }"
  end
end
