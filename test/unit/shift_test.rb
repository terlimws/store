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
  should allow_value(Time.now).for(:start_time)
  should allow_value(4.hours.ago).for(:start_time)
  should allow_value(3.hours.ago).for(:start_time)
  should allow_value(1.hour.from_now).for(:start_time)
  should_not allow_value(nil).for(:start_time)
  
  # for end time
  should allow_value(nil).for(:end_time)


  # ---------------------------------
  # Testing other methods with a context
  context "test" do
    # create the objects I want with factories
    setup do 
      @ed = Factory(:employee)
      @cmu = Factory(:store)
      @assignment1 = Factory(:assignment, :store => @cmu, :employee => @ed)
      @shift1 = Factory(:shift, :assignment => @assignment1, :date => Date.today, :start_time => Time.now, :end_time => nil, :notes => nil)
    end
    
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cmu.destroy
      @assignment1.destroy
      @shift1.destroy
    end
  
    #test the scope 'for_employee'
    should "show that the shift for employee 1 is shift1" do
      s =  Shift.for_employee(1).map{|o| o}
      assert_equal @shift1, s[0]
    end
    
  end
end
