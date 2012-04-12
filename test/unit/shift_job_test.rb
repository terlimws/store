require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase

  # Relationship macros...
  should belong_to(:shift)
  should belong_to(:job)
  
  # Validation macros...
  should validate_presence_of(:shift_id)
  should validate_presence_of(:job_id)
  
  ## ---------------------------------
  # Testing other methods with a context
  context "test" do
    # create the objects I want with factories
    setup do 
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @cmu = FactoryGirl.create(:store)
      @assignment1 = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @ed)
      @assignment2 = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @cindy)
      @shift1 = FactoryGirl.create(:shift, :date => Date.today, :assignment => @assignment1, :end_time => Time.local(2012,12,8,23,0,0))
      @shift2 = FactoryGirl.create(:shift, :assignment => @assignment2, :date => Date.today, :end_time => Time.local(2000,1,1,11,0,1))
      @sweepfloor = FactoryGirl.create(:job)
    end
    
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cindy.destroy
      @cmu.destroy
      @assignment1.destroy
      @assignment2.destroy
      @shift1.destroy
      @shift2.destroy
      @sweepfloor.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert @ed.active
      assert @cindy.active
      assert @assignment1.active?
      assert @assignment2.active?
      assert @shift1.is_current
      assert @shift2.has_ended
      assert_equal "Clean the toilet", @sweepfloor.name
    end
  
    # test shift_id cannot be empty
    should "not allow shift_id to be empty" do
      sweepfloor = FactoryGirl.build(:job)
      shiftjob1 = FactoryGirl.build(:shift_job, :job => @sweepfloor, :shift => nil)
      deny shiftjob1.valid?
    end
  
    # test job_id cannot be empty
    should "not allow job_id tp be empty" do
      shiftjob1 = FactoryGirl.build(:shift_job, :job => nil, :shift => @shift1)
      deny shiftjob1.valid?
    end
    
    # test jobs cannot be added to shifts until shift end time has past
    should "not allow jobs to be added to shift until shift is over" do
      sweepfloor = FactoryGirl.build(:job)
      shiftjob1 = FactoryGirl.build(:shift_job, :job => @sweepfloor, :shift => @shift1)
      completed_shifts_id = Shift.all.map {|x| x.id if x.end_time < Time.now}
      deny shiftjob1.valid?
    end
  
    should "allow jobs to be added to shift when shift is over" do
      testshiftjob = FactoryGirl.build(:shift_job, :job => @sweepfloor, :shift => @shift2)
      assert testshiftjob.valid?
    end
  end
end
