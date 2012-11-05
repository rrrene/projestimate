require "spec_helper"

describe Project do

  before :each do
    #@project = Factory.build :project
    @project = Project.first
    @another_project = Project.first
  end

  it 'should be not valid' do
    @project.should be_valid
  end

  it 'should have 7 states' do
    Project.aasm_states_for_select.size.should eql(7)
  end

  it "should return his root component" do
    @project.root_component.id.should eql(@project.wbs.components.first.id)
  end

  it "should return a good project attribute value" do
     #TODO
  end

  it "should execute correctly a estimation plan" do
     #TODO
  end

  it "should generate a folders array" do
     #TODO
  end

  it "should raise an error" do
     #TODO
  end

  after :each do
    #clean up
  end

end