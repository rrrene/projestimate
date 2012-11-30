require "spec_helper"

describe User do

  before :each do
    @admin1 =  User.first
    @admin = User.new(admin_user_hash)  #defined below
    @user = User.new(valid_user_hash)  #defined below
  end


  it "should be valid" do
    @admin.should be_valid
    @user.should be_valid
  end

  #ATTRIBUTES AND FORMAT VALIDATIONS

  it "should not be valid without last_name"  do
    @user.last_name=''
    @user.should_not be_valid
  end

  it "should not be valid without first_name"  do
    @user.first_name=''
    @user.should_not be_valid
  end

  #Validating login_name
  it "should not be valid without login_name"  do
    @user.login_name=''
    @user.should_not be_valid
  end

  describe "when login_name is already taken" do
    before do
      user = User.first
      @user_with_same_login = user.dup
      @user_with_same_login.login_name = user.login_name.upcase
      @user_with_same_login.save
    end

    it "should not be_valid" do
      @user_with_same_login.should_not be_valid
    end
  end

  #Validating Email address
  it "should not be valid without email"  do
    @user.email =''
    @user.should_not be_valid
  end

  it "should not be valid when email is nil" do
    @user.email = "test@moi.fr"
    @user.email.should match(/\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/i)
  end

  it "should check for email format validation" do
    @user.email =
    @user.should_not have(1).errors_on(:email)
    @user.should_not be_valid
  end

  describe "when email address is already taken" do
    before do
      user = User.first
      @user_with_same_email = user.dup
      @user_with_same_email.email = user.email.upcase
      @user_with_same_email.save
    end

    it "should not be valid" do
      @user_with_same_email.should_not be_valid
    end
  end

  it "should not be valid without user_status" do
    @user.user_status=''
    @user.should be_valid
  end

  it "should not be valid without auth_type"  do
    @user.auth_type=''
    @user.should_not be_valid
  end

  it "should not be valid without password"  do
    @user.password=''
    @user.should_not be_valid
  end

  it "should not be valid without password_confirmation"  do
    @user.password_confirmation=''
    @user.should_not be_valid
  end

  # This can happen at the Console: because when password_confirmation is 'nil', Rails doesn't run validation
  it "should not be valid when password confirmation is nil" do
    @admin.password_confirmation = nil
    @admin.should_not be_valid
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation= "changed_pass" }

    it "should not be valid" do
      @user.should_not be_valid
    end
  end

  describe "when password is too short" do
    before do
      #password_min_length = AdminSetting.new(:key => "password_min_length", :value => "4")
      #password_min_length.save
      @user.password = @user.password_confirmation = "abc"
    end
    it "should not be valid when password is too short" do
      @user.should_not be_valid
    end
  end


  #AUTHENTICATION VALIDATION

  describe "return value of authenticate method" do
    #before { @new_user =  User.new( :last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'admin', :email => 'youremail@yourcompany.net', :user_status => 'active', :auth_type => 6, :password => 'projestimate', :password_confirmation => 'projestimate') }
    before { @new_user = User.first }

    subject {@new_user}

    let(:found_user) { User.find_by_email(@new_user.email) }

    describe "with valid password" do
      it { should == User.authenticate(@new_user.login_name, @new_user.password) }
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { User.authenticate(@new_user.login_name, "invalid") }
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false}
    end
  end


  #METHODS AND OTHERS VALIDATIONS

  it "should be activated by admin" do
    @admin.user_status.should eql('active')
    @admin.should be_valid
  end


  it "should be in pending mode waiting for validation" do
    @user.user_status.should eql('pending')
    @user.user_status='pending'
    @user.should be_valid
  end

  #check admin status
  it "should not be an admin account" do
    @user.auth_type.should_not eql(6)
    @user.should be_valid
  end

  it "should not be an suspending account" do
    @user.user_status.should_not eql('suspending')
    @user.user_status='active'
    @user.should be_valid
  end

  it "should be blacklisted" do
    @user.user_status='blacklisted'
    @user.should be_valid
  end

  it "should have a valid name =  first_name + " " + last_name" do
    @user.name.should eql(@user.first_name+ " " + @user.last_name)
  end


  #AASM STATES

  it "should initially have user_status as :pending" do
    #@user.user_status = "active"
    @user.user_status.should eql("pending")
  end

  #it "should set user_status to 'active' as default status when admin is the author" do
  #  @user = User.new(:last_name => 'test_last_name', :first_name => 'test_first_name', :login_name => 'test', :email => 'email@test.fr', :user_status => 'pending', :auth_type => 1, :password => 'test', :password_confirmation => 'test')
  #  @user.user_status.should == 'active'
  #end

  it "should set user_status to 'active' when transition to :active" do
    lambda { @user.switch_to_active! }.should change(@user, :user_status).from('pending').to('active')
    @user.user_status = 'suspended'
    lambda { @user.switch_to_active! }.should change(@user, :user_status).from('suspended').to('active')
    @user.user_status = 'blacklisted'
    lambda { @user.switch_to_active! }.should change(@user, :user_status).from('blacklisted').to('active')
  end

  it "should set user_status to 'suspended' when transition to :suspended" do
    lambda { @user.switch_to_suspended! }.should change(@user, :user_status).from('pending').to('suspended')
    @user.user_status = 'active'
    lambda { @user.switch_to_suspended! }.should change(@user, :user_status).from('active').to('suspended')
    @user.user_status = 'blacklisted'
    lambda { @user.switch_to_suspended! }.should change(@user, :user_status).from('blacklisted').to('suspended')
  end

  it "should set user_status to 'blacklisted' when transition to :blacklisted" do
    @user.user_status = 'suspended'
    lambda { @user.switch_to_blacklisted! }.should change(@user, :user_status).from('suspended').to('blacklisted')
    @user.user_status = 'active'
    lambda { @user.switch_to_blacklisted! }.should change(@user, :user_status).from('active').to('blacklisted')
    @user.user_status = 'pending'
    lambda { @user.switch_to_blacklisted! }.should change(@user, :user_status).from('pending').to('blacklisted')
  end

  it "should set user_status to :pending when transition to :pending" do
    @user.user_status = 'suspended'
    lambda { @user.switch_to_pending! }.should change(@user, :user_status).from('suspended').to('pending')
    @user.user_status = 'active'
    lambda { @user.switch_to_pending! }.should change(@user, :user_status).from('active').to('pending')
    @user.user_status = 'blacklisted'
    lambda { @user.switch_to_pending! }.should change(@user, :user_status).from('blacklisted').to('pending')
  end


  it "should be have Nom Prenom" do
    @admin.name.should eq("Administrator Projestimate")
  end

  it "should return groups array (globals permissions)" do
  end

  it "should return groups array (specific permissions)" do
  end

  it "should be authenticate by the application" do
  end

  it "should be authenticate by the a LDAP directory" do
  end

  it "should be an admin if he had admin right" do
  end

  it "should be delete recent projects" do
  end

  it "should be add recent projects" do
  end

  it "should return a search result (using for datatables plugins)" do
  end


  def valid_user_hash
    {:last_name => 'test_last_name', :first_name => 'test_first_name', :login_name => 'test', :email => 'email@test.fr', :user_status => 'pending', :auth_type => 1, :password => 'test', :password_confirmation => 'test'}
  end


  def admin_user_hash
    {:last_name => 'Projestimate', :first_name => 'Administrator', :login_name => 'administrator', :email => 'admin@yourcompany.net', :user_status => 'active', :auth_type => 6, :password => 'test', :password_confirmation => 'test'}
  end

end