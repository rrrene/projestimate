require 'spec_helper'

describe Project do

  setup do
    @project = Factory.build :project
  end

  it 'should be valid' do
    assert @project.valid?
  end

  #it "should return his root component" do
  #   #TODO
  #end
  #
  #it "should return a verbose processus" do
  #   #TODO
  #end
  #
  #it "should return a good project attribute value" do
  #   #TODO
  #end
  #
  #it "should execute correctly a estimation plan" do
  #   #TODO
  #end
  #
  #it "should generate an estimation flow" do
  #   #TODO
  #end

end