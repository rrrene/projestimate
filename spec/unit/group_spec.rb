require "spec_helper"

describe Group do
  before :each do
    @group = Group.first
    @project = Project.first
  end

  it 'should be valid' do
    @group.should be_valid
  end

  it 'should return an array' do
    #@group.project_securities_for_select(@project.id).should be_a_kind_of(Array)
  end
end