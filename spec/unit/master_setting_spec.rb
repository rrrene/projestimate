require "spec_helper"

describe MasterSetting do

  before :each do
    @ms = FactoryGirl.create(:master_setting_wiki_url)
    @proposed_status = FactoryGirl.build(:proposed_status)
    @custom_status = FactoryGirl.build(:custom_status)
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

  it "should not be valid without custom_value when record_status='Custom'" do
    @ms.record_status = @custom_status
    @ms.should_not be_valid
  end

  it "should not be valid with duplicated key" do
    ms2 = @ms.dup
    ms2.key = @ms.key
    ms2.record_status = @proposed_status
    ms2.save
    ms2.should_not be_valid
  end

end