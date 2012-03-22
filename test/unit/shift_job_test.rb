require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase

  # Relationship macros...
  should belong_to(:shift)
  should belong_to(:job)
  
  # Validation Macros
  should validate_presence_of(:job_id)
  should validate_presence_of(:shift_id)
  
  # ---------------------------------
  # Testing other methods with a context
  #context "Creating 1 employee, 1 store, 1 assignment and 1 job" do
  #  # create the objects I want with factories
  #  setup do
  #    # Creating 1 employee
  #    @terence = Factory(:employee, :first_name => "Terence", :last_name => "Lim", :ssn => "188860275", :date_of_birth => 23.years.ago.to_date, :phone => "412-805-4522", :role => "admin", :active => true)
  #    
  #    # Creating 1 store
  #    @upitt = Factory.create(:store, :name => "UPitts", :street => "5002 Fifth Avenue", :city => "Pittsburgh", :state => "PA", :zip => "15210", :phone => "1234567289", :active => true)
  #    
  #    # Creating total of 1 assignment
  #    @assignment3 = Factory(:assignment, :store => @upitt, :employee => @terence, :start_date => 5.months.ago.to_date, :end_date => nil, :pay_level => 3)
  #
  #    # Creating 1 job
  #    @serve_icecream = Factory.create(:job, :name => "Serve Ice Cream", :description => "Give customers more ice cream", :active => true)
  #    
  #    # Creating 1 shift
  #    @shift1 = Factory(:shift, :assignment => @assignment3, :date => Date.today, :start_time => Time.now, :end_time => nil, :notes => nil)
  #    
  #    # Creating 1 shiftjob
  #    @shiftjob1 = Factory.create(:shiftjob, :job => @serve_icecream, :shift => @shift1)
  #  end
  #  
  #  # and provide a teardown method as well
  #  teardown do
  #    @terence.destroy
  #    @upitt.destroy
  #    @assignment3.destroy
  #    @serve_icecream.destroy
  #  end
  #  
  #  # test the scope 'for_employee'
  #  should "shows that there is 1 shift_job for employee_id = 4" do
  #    a = ShiftJob.for_job(1).map{|o| o.id}
  #    assert_equal 2, a.size
  #  end
  
    # test the custom validation 'job_is_active_in_creamery_system'
    # ensures that new assignments have employees that are active in the system
    #should "identify a shift_job with a non-active job as invalid" do
    #  @mop_floor = Factory.create(:job, :name => "Mop the floor", :description => "Take a mop and move it", :active => false)
    #  invalid_shift_job = Factory.build(:shiftjob, :shift => @shift1, :job => @mop_floor)
    #  deny invalid_shift_job.valid?
    #  @mop_floor.destroy
    #end
end
