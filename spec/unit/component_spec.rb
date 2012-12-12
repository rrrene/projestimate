require "spec_helper"

describe Component do

  before :each do
    #@component = Component.first
    @component = FactoryGirl.create(:component)
    @c1 = Component.new(:name => "C1")
    @c2 = Component.new(:name => "C1")
  end

  it 'should be valid' do
    @component.should be_valid
  end

  it "should be not valid without name" do
    @component.name = ""
    @component.should_not be_valid
  end

  it "should return :component name" do
    @component.to_s.should eql(@component.name)
  end

  #TODO
  #it 'should have a correct type' do
  #  @component.folder?.should be_true
  #end

  it "should be root" do
    @component.is_root.should be_true
  end
end
