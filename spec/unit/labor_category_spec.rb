require "spec_helper"

describe LaborCategory do

  before :each do
    #@labor = LaborCategory.first
    @labor = FactoryGirl.create(:labor_category)
  end

  it 'should be valid' do
    @labor.should be_valid
  end

  #it "should have a secure token" do
  #  @labor.should_receive(:secure_token)
  #end

  it "should not be valid without name" do
    @labor.name = ""
    @labor.should_not be_valid
  end
end