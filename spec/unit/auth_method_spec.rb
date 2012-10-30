

describe AuthMethod do
  before :each do
    @default_auth_method = AuthMethod.first
    @another_auth_method = AuthMethod.new(:name => "LDAP", :server_url => "example.com", :port => 636, :base_dn => "something", :certificate => "simple_tls")
  end

  it 'should be valid' do
    @default_auth_method.should be_valid
    @another_auth_method.should be_valid
  end

  it 'should display correct name' do
    @default_auth_method.to_s.should eql("Applicatif")
    @another_auth_method.to_s.should_not eql("app")
  end

  it 'should bind and return a boolean' do
    #NET::LDAP to do...
  end

end