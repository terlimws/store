require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # Relationship macros...
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)
  
  # Validation macros...
  should validate_presence_of(:name)
  
  # ---------------------------------
  # Testing other methods with a context
  context "Creating three jobs" do
    # create the objects I want with factories
    setup do
      @mop_floor = FactoryGirl.create(:job, :name => "Mop the floor", :description => "Take a mop and move it", :active => false)
      @serve_icecream = FactoryGirl.create(:job, :name => "Serve Ice Cream", :description => "Give customers more ice cream", :active => true)
      @cash_register = FactoryGirl.create(:job, :name => "Work Cash Register", :description => "Work the Cash Resister", :active => true)
    end
    
    # and provide a teardown method as well
    teardown do
      @mop_floor.destroy
      @serve_icecream.destroy
      @cash_register.destroy
    end
  
    # test the scope 'active'
    should "shows that there are two active jobs" do
      assert_equal 2, Job.active.size
      assert_equal ["Serve Ice Cream", "Work Cash Register"], Job.active.map{|o| o.name}
    end
    
    # test the scope 'inactive'
    should "shows that there is 1 inactive job" do
      assert_equal 1, Job.inactive.size
      assert_equal ["Mop the floor"], Job.inactive.map{|o| o.name}
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three jobs in alphabetical order" do
      assert_equal ["Mop the floor", "Serve Ice Cream", "Work Cash Register"], Job.alphabetical.map{|o| o.name}
    end
    
  end

end
