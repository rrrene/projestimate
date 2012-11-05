require "spec_helper"

describe MasterSetting do

  before :each do
    @ms = MasterSetting.first
  end

  it 'should be valid' do
    @ms.should be_valid
  end

end