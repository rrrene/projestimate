require "spec_helper"

describe LaborCategory do

  before :each do
    #@labor = LaborCategory.first
    @labor = FactoryGirl.create(:labor_category)
    @proposed_status = FactoryGirl.build(:proposed_status)
    @custom_status = FactoryGirl.build(:custom_status)
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

  it "should not be valid without custom_value when record_status='Custom'" do
    @labor.record_status = @custom_status
    @labor.should_not be_valid
  end

  it "should not be valid when name is already taken" do
    @labor2 = @labor.dup
    @labor2.save
    @labor2.should_not be_valid
  end
end