require "spec_helper"

describe AuthMethod do
  before :each do
    @default_auth_method = FactoryGirl.create(:auth_method)
    proposed_status = FactoryGirl.build(:proposed_status)
    @another_auth_method = AuthMethod.new(:name => "LDAP", :server_name => "example.com", :port => 636, :base_dn => "something", :certificate => "simple_tls", :uuid => "124563", :record_status => proposed_status)
  end

  it 'should be valid' do
    @default_auth_method.should be_valid
    @another_auth_method.should be_valid
  end

  it 'should display correct name' do
    @default_auth_method.to_s.should match(/Application_\d/)
    @another_auth_method.to_s.should_not match(/Application_\d/)
  end

  it 'should not be valid without UUID' do
    @default_auth_method.uuid = ""
    @default_auth_method.should_not be_valid
  end

  it 'should not be valid without record status' do
    @default_auth_method.record_status = nil
    @default_auth_method.should_not be_valid
  end

  it 'should bind and return a boolean' do
    #NET::LDAP to do...
  end

end