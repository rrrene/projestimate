require "spec_helper"

describe LaborCategory do

  before :each do
    @labor = LaborCategory.first
  end

  it 'should be valid' do
    @labor.should be_valid
  end
end