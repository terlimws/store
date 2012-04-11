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
  # for date
  should allow_value(7.weeks.ago.to_date).for(:date)
  should allow_value(2.years.ago.to_date).for(:date)
  should allow_value(1.week.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)
  
  # for start time
  should allow_value(Time.local(2000,1,1,11,0,0)).for(:start_time)
  should allow_value(Time.local(2000,1,1,23,0,0)).for(:start_time)
  should_not allow_value(nil).for(:start_time)

  ## ---------------------------------
  ## Testing other methods with a context
  context "test" do
    # create the objects I want with factories
    setup do 
      @ed = FactoryGirl.create(:employee)
      @cindy = FactoryGirl.create(:employee, :first_name => "Cindy", :last_name => "Crawford", :ssn => "084-35-9822", :date_of_birth => 17.years.ago.to_date)
      @ralph = FactoryGirl.create(:employee, :first_name => "Ralph", :last_name => "Wilson", :date_of_birth => 16.years.ago.to_date)
      @cmu = FactoryGirl.create(:store)
      @assignment1 = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @ed)
      @assignment2 = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @cindy)
      @assignment3 = FactoryGirl.create(:assignment, :store => @cmu, :end_date => nil, :employee => @ralph)
      @shift1 = FactoryGirl.create(:shift, :assignment => @assignment1)
      @shift2 = FactoryGirl.create(:shift, :assignment => @assignment2, :date => 2.days.from_now, :end_time => Time.local(2000,1,1,11,0,1))
      @shift3 = FactoryGirl.create(:shift, :assignment => @assignment3, :date => 1.day.ago.to_date)
      @sweepfloor = FactoryGirl.create(:job)
      @mopfloor = FactoryGirl.create(:job, :name => "Mopped the floor")
      @shiftjob1 = FactoryGirl.create(:shift_job, :shift => @shift2, :job => @sweepfloor)
      @shiftjob2 = FactoryGirl.create(:shift_job, :shift => @shift2, :job => @mopfloor)
    end
    
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      @cindy.destroy
      @ralph.destroy
      @cmu.destroy
      @assignment1.destroy
      @assignment2.destroy
      @assignment3.destroy
      @shift1.destroy
      @shift2.destroy
      @shift3.destroy
      @sweepfloor.destroy
      @mopfloor.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert @ed.active
      assert @cindy.active
      assert @ralph.active
      assert @assignment1.active?
      assert @assignment2.active?
      assert @assignment3.active?
      assert @shift1.has_ended
      assert @shift2.has_ended
      assert @shift3.has_ended
      assert_equal "Clean the toilet", @sweepfloor.name
      assert_equal "Mopped the floor", @mopfloor.name
    end
    
    # test scope completed
    should "return shifts with at least 1 job linked to it" do
      assert_equal 2, @shift2.jobs.count
      assert_equal 1, Shift.completed.size
      assert_equal [2], Shift.completed.map{|s| s.id}
    end

    # test scope incomplete
    should "return shifts with no jobs linked to it" do
      assert_equal 0, @shift1.jobs.count
      assert_equal 2, Shift.incomplete.size
      assert_equal [1,3], Shift.incomplete.map{|s| s.id}
    end  

    # test scope for store
    should "return shifts linked to a store" do
      assert_equal 3, Shift.for_store(@cmu).size
      assert_equal [1,2,3], Shift.for_store(@cmu).map{|s| s.id}
    end  

    # test scope for employee
    should "return shifts linked to a employee" do
      assert_equal 1, Shift.for_employee(@cindy).size
      assert_equal [2], Shift.for_employee(@cindy).map{|s| s.id}
      assert_equal 1, Shift.for_employee(@ed).size
      assert_equal [1], Shift.for_employee(@ed).map{|s| s.id}      
    end   
    
    # test scope for assignmnet
    should "return shifts linked to an assignment" do
      assert_equal 1, Shift.for_assignment(@assignment2).size
      assert_equal [2], Shift.for_assignment(@assignment2).map{|s| s.id}
      assert_equal 1, Shift.for_assignment(@assignment1).size
    end 
    
    #test scope for past
    should "return shifts that have a date in the past" do
      assert_equal 2, Shift.past.size
      assert_equal [1,3], Shift.past.chronological.map{|s| s.id}
    end 
    
    #test scope for upcoming
    should "return shifts that have a date in the future" do
      assert_equal 1, Shift.upcoming.size
      assert_equal [2], Shift.upcoming.map{|s| s.id}
    end
    
    #test scope for the next * days
    should "return shifts that are in the next * days" do
      assert_equal 1, Shift.for_next_days(2).size
      assert_equal [2], Shift.for_next_days(2).map{|s| s.id}
    end

    #test scope for the past * days
    should "return shifts that were in the past * days" do
      assert_equal 2, Shift.for_past_days(10).size
      assert_equal [1,3], Shift.for_past_days(3).map{|s| s.id}
    end

    #test scope for chronological
    should "return shifts in chronological order" do
      assert_equal [1,3,2], Shift.chronological.map{|s| s.id}
    end

  end

  ## orders values by store  
  #scope :by_store, joins(:store).order('name')
  #
  ## orders values by employee's last, first names
  #scope :by_employee, joins(:employee).order('last_name, first_name')
  #
  ## return all shifts that has ended
  #scope :ended_shifts, where('end_time < ?', Time.now)
end
