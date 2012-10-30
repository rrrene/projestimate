

describe AdminSetting do
  before :each do
    @admin_setting = AdminSetting.first
  end

  it 'should be valid' do
    @admin_setting.should be_valid
  end
end