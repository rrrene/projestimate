require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
      before(:each) do
        ActionMailer::Base.deliveries = []

        @user = FactoryGirl.create(:user)
        @mailerCreated = UserMailer.account_created(@user)
        @mailerValidateLDAP=UserMailer.account_validate_ldap(@user)
        @mailerAccountsuspended=UserMailer.account_suspended(@user)
        @mailerNew=UserMailer.new_password(@user)
        @mailerForgottenPassword=UserMailer.forgotten_password(@user)
        @mailerAccountRequest=UserMailer.account_request()
        @mailerAccountValidate=UserMailer.account_validate(@user)
        @mailerAccountValidateNoPw=UserMailer.account_validate_no_pw(@user)
      end

      describe "Created" do
        it "should have Subject ProjEstimate Account created" do
          @mailerCreated.subject.should eq('ProjEstimate Account created')
        end
        it "should have to user mail from created mail" do
          @mailerCreated.to[0].should==(@user.email)
        end
        #it "should send Account created emails" do
        #  @mailerCreated.deliver
        #end
      end
      describe "Validate LDAP" do
        it "should have Subject Your ProjEstimate account has changed" do
          @mailerValidateLDAP.subject.should eq('Your ProjEstimate account has changed')
        end
        it "should have to user mail from validateLDAP" do
          @mailerValidateLDAP.to[0].should==(@user.email)
        end
        #it "should send Account validatedLDAP emails" do
        #  @mailerValidateLDAP.deliver
        #end
      end
      describe "Account suspended" do
        it "should have Subject Your ProjEstimate account has changed" do
          @mailerAccountsuspended.subject.should eq('Your ProjEstimate account has been suspended')
        end
        it "should have to user mail from validateLDAP" do
          @mailerAccountsuspended.to[0].should==(@user.email)
        end
        #it "should send Account suspended emails" do
        #  @mailerAccountsuspended.deliver
        #end
      end
      describe "Reset password" do
        it "should have Subject Your ProjEstimate password has changed" do
          @mailerNew.subject.should eq('Your ProjEstimate password has changed')
        end
        it "should have to user mail from new password" do
          @mailerNew.to[0].should==(@user.email)
        end
        #it "should send password reseted emails" do
        #  @mailerNew.deliver
        #end
      end
      describe "Forgotten password" do
      #Don't modifie please: tests are in echec because the method FOrgotten Password is not fonctionnal'
        it "should have Subject Projestimate - New password" do
          @mailerForgottenPassword.subject.should eq('Projestimate - New password')
        end
        it "should have to user mail from forgotten password" do
          @mailerForgottenPassword.to[0].should==(@user.email)
        end
        #it "should send reset password emails" do
        #  @mailerAccountValidate.deliver
        #end
      end
      describe "New account request" do
        it "should have Subject New account request" do
          @mailerAccountRequest.subject.should eq('New account request')
        end
        it "should have to user mail from New account request" do
          @mailerAccountRequest.to[0].should==(AdminSetting.find_by_key("notifications_email").value)
        end
        #it "should send new account request emails" do
        #  @mailerAccountRequest.deliver
        #end
      end
      describe "Account validated" do
        it "should have Subject Your ProjEstimate account is validated" do
          @mailerAccountValidate.subject.should eq('Your ProjEstimate account is validated')
        end
        it "should have to user mail from Account Validate" do
          @mailerAccountValidate.to[0].should==(@user.email)
        end
        #it "should send Account validated emails" do
        #  @mailerAccountValidate.deliver
        #end
      end
      describe "Account validated without password" do
        it "should have Subject Your ProjEstimate account has been validated" do
          @mailerAccountValidateNoPw.subject.should eq('Your ProjEstimate account has been validated')
        end
        it "should have to user mail from Account Validate without password" do
          @mailerAccountValidateNoPw.to[0].should==(@user.email)
        end
        #it "should send Account ValidateNoPw emails" do
        #  @mailerAccountValidateNoPw.deliver
        #end
      end

end

