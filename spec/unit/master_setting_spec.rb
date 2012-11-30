require "spec_helper"

describe MasterSetting do

  before :each do
    @ms = MasterSetting.first
  end

  it 'should be valid' do
    @ms.should be_valid
  end

  it "should not be valid without :key" do
    @ms.key = ""
    @ms.should_not be_valid
  end

  it "should not be valid without :value" do
    @ms.value = ""
    @ms.should_not be_valid
  end

  it "should not be valid with duplicated key" do
    ms2 = @ms.dup
    ms2.save
    ms2.should_not be_valid
  end

end