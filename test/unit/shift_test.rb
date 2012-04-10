require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  
  # Relationship macros...
  should belong_to(:assignment)
  should have_many(:shift_jobs)
  should have_many(:jobs).through(:shift_jobs)
  should have_one(:store).through(:assignment)
  should have_one(:employee).through(:assignment)

  
  # Validation macros...
  should validate_presence_of(:assignment_id)
  should validate_presence_of(:date)
  should validate_presence_of(:start_time)


  # Test basic validations
  # for assignment id
  should allow_value(1).for(:assignment_id)
  should allow_value(2).for(:assignment_id)
  should allow_value(3).for(:assignment_id)
  should allow_value(4).for(:assignment_id)
  should allow_value(5).for(:assignment_id)
  should allow_value(6).for(:assignment_id)
  should_not allow_value("bad").for(:assignment_id)
  should_not allow_value(0).for(:assignment_id)
  should_not allow_value(2.5).for(:assignment_id)
  should_not allow_value(-2).for(:assignment_id)
  
  ## for date
  should allow_value(7.weeks.ago.to_date).for(:date)
  should allow_value(2.years.ago.to_date).for(:date)
  should allow_value(1.week.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)
  
  ## for start time
  should_not allow_value(nil).for(:start_time)
  
  # for end time
  should allow_value(nil).for(:end_time)


  # ---------------------------------
  # Testing other methods with a context
  context "Shift Tests" do
    # create the objects I want with factories
    setup do 
      @ed = Factory(:employee)
      @cmu = Factory(:store)
      @assignment1 = Factory(:assignment, :store => @cmu, :employee => @ed)
      @job1 = Factory(:job)
      @shift1 = Factory(:shift, :assignment => @assignment1, :date => Time.local(2000,11,11,11,11,11).to_date, :start_time => Time.local(2000,11,11,11,11,11), :end_time => nil, :notes => nil)
      @shift_job = Factory(:shift_job, :job => @job1, :shift => @shift1)
    end
    
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cmu.destroy
      @assignment1.destroy
      @job1.destroy
      @shift1.destroy
      @shift_job.destroy
    end
    
    #test the scope 'for_employee'
    should "show that the shift for employee 1 is shift1" do
      s =  Shift.for_employee(@ed.id).map{|o| o}
      assert_equal 1, s.size
      assert_equal @shift1, s.first
    end
    
    #test the scope completed
    should "show that the shift for employee 1 is completed" do
      s =  Shift.completed.map{|o| o}
      assert_equal 1, s.size
    end
    
    #test the scope incomplete
    should "show that no shifts for incomplete" do
      s =  Shift.incomplete.map{|o| o}
      assert_equal 0, s.size
    end
  end
end
