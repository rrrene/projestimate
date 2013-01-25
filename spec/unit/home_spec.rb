require "spec_helper"

describe Home do

  it 'should be success' do
    Home::update_master_data!.should be_success
  end

end