require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  
  # Relationship macros...
  should belong_to(:assignment)
  #should have_many(:shift_jobs)
  #should have_many(:jobs).through(:shift_jobs)

  
  # Validation macros...
  should validate_presence_of(:assignment_id)
  should validate_presence_of(:date)
  should validate_presence_of(:start_time)


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

    #test the scope 'by_start_time'
    should "show that there is one shift ordered by start_time" do
      assert_equal [1], Shift.by_start_time.map{|o| o.assignment_id}
    end
    
  end
end
