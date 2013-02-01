require "spec_helper"

describe AdminSetting do
  before :each do
    @admin_setting = FactoryGirl.create(:welcome_message_ad)
    @proposed_status = FactoryGirl.build(:proposed_status)
    @custom_status = FactoryGirl.build(:custom_status)
  end

  it 'should be valid' do
    @admin_setting.should be_valid
  end

  it "should be not valid without key" do
    @admin_setting.key=""
    @admin_setting.should_not be_valid
  end

  it "should not have duplicated keys" do
    @admin_setting2 = @admin_setting.dup
    @admin_setting2.key = @admin_setting.key
    @admin_setting2.save
    @admin_setting2.should_not be_valid
  end

  it "should be not valid without value" do
    @admin_setting.value=""
    @admin_setting.should_not be_valid
  end


  it "should not be valid without custom_value when record_status='Custom'" do
    @admin_setting.record_status = @custom_status
    @admin_setting.should_not be_valid
  end

end