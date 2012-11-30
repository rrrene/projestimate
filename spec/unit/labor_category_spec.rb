require "spec_helper"

describe LaborCategory do

  before :each do
    @labor = LaborCategory.first
  end

  it 'should be valid' do
    @labor.should be_valid
  end

  it "should not be valid without name" do
    @labor.name = ""
    @labor.should_not be_valid
  end
end