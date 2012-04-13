require 'test_helper'

class UserTest < ActiveSupport::TestCase


  # Test relationships
  should belong_to(:employee)
  
  # Test basic validations
  should validate_presence_of(:employee_id)
  should validate_presence_of(:email)
  should validate_presence_of(:password_digest)

  # Test format of email
  should allow_value("wanxint@andrew.cmu.edu").for(:email)
  should allow_value("teo.wan.xin@gmail.com").for(:email)
  should allow_value("jzf@yahoo.com.sg").for(:email)
  should_not allow_value("bad").for(:email)  
  should_not allow_value("bad@yahoo,com").for(:email)
  should_not allow_value("twitter.com").for(:email)

  context "Creating 1 user" do
    # create the objects I want with factories
    setup do 
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :active => false)
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :date_of_birth => 16.years.ago.to_date)
      @eduser = FactoryGirl.create(:user, :employee_id => @ed.id, :email => "weishanl@andrew.cmu.edu", :password => "secret")
    end
    
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cindy.destroy
      @ralph.destroy
      @eduser.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert @ed.active
      deny @cindy.active
      assert @ralph.active
      #assert_equal "wanxint@andrew.cmu.edu", @eduser.email
    end
    
    # test employees must have unique email
    should "force employees to have unique email" do
      repeat_email = FactoryGirl.build(:user, :employee => @ralph, :email => "weishanl@andrew.cmu.edu")
      deny repeat_email.valid?
    end
    
    # test employees must be active
    should "force employees to be active" do
      inactive_cindy = FactoryGirl.build(:user, :employee => @cindy, :email => "jzf@andrew.cmu.edu", :password_digest => "werwer")
      deny inactive_cindy.valid?
    end
    
    # test the self.authentication method
    should "show that the user email is correct if authenticated" do
      user = User.authentication("a","a")
      user2 = User.authentication("weishanl@andrew.cmu.edu","secret")
      assert_equal nil, user
      assert_equal "weishanl@andrew.cmu.edu", user2.email
    end
    
    
  end

end
