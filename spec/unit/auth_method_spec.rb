require "spec_helper"

describe AuthMethod do
  before :each do
    @default_auth_method = FactoryGirl.create(:auth_method)
    proposed_status = FactoryGirl.build(:proposed_status)
    @another_auth_method = AuthMethod.new(:user_name_attribute => "cn", :name => "LDAP", :server_name => "example.com", :port => 636, :base_dn => "something", :encryption => "simple_tls", :uuid => "124563", :record_status => proposed_status)
    @custom_status = FactoryGirl.build(:custom_status)
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

  it "should not be valid without custom_value when record_status='Custom'" do
    @default_auth_method.record_status = @custom_status
    @default_auth_method.should_not be_valid
  end

  it 'should bind and return a boolean' do
    #NET::LDAP to do...
  end
  it "should duplicate auth method" do
    @default_auth_method2=@default_auth_method.amoeba_dup
    @default_auth_method2.record_status.name.should eql("Proposed")
    @default_auth_method2.reference_id = @default_auth_method.id
    @default_auth_method2.reference_uuid = @default_auth_method.uuid
  end

  it "should display ecncryption" do
    @another_auth_method.encryption2.should eql("")
    @another_auth_method.encryption = 'No encryption'
    @another_auth_method.encryption2.should eql("")
    @another_auth_method.encryption = 'SSL (ldaps://)'
    @another_auth_method.encryption2.should eql(:simple_tls)
    @another_auth_method.encryption = 'StartTLS'
    @another_auth_method.encryption2.should eql(:start_tls)
  end


end