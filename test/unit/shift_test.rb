require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  
  # Relationship macros...
  should belong_to(:assignment)
  should have_many(:shift_jobs)
  should have_many(:jobs).through(:shift_jobs)

  
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
      #@terence = Factory(:employee, :first_name => "Terence", :last_name => "Lim", :ssn => "188860275", :date_of_birth => 23.years.ago.to_date, :phone => "4128054522", :role => "admin", :active => true)
      #@miko = Factory(:employee, :first_name => "Miko", :last_name => "Bautista", :ssn => "184821637", :date_of_birth => 18.years.ago.to_date, :phone => "4129991723", :role => "employee", :active => false)
      #@tom = Factory(:employee, :first_name => "Tom", :last_name => "Cortina", :ssn => "188260975", :date_of_birth => 15.years.ago.to_date, :phone => "4108054513", :role => "employee", :active => true)
      #@kevin = Factory(:employee, :first_name => "Kevin", :last_name => "Liew", :ssn => "192260971", :date_of_birth => 19.years.ago.to_date, :phone => "5103054523", :role => "manager", :active => true)

      @cmu = Factory(:store)
      #@upitt = Factory(:store, :name => "UPitts", :street => "5002 Fifth Avenue", :city => "Pittsburgh", :state => "PA", :zip => "15210", :phone => "1234567289", :active => true)
      #@chartham = Factory(:store, :name => "Chartham", :street => "5020 Fifth Avenue", :city => "Pittsburgh", :state => "PA", :zip => "15223", :phone => "193-553-2235", :active => false)
      
      @assignment1 = Factory(:assignment, :store => @cmu, :employee => @ed)
      #@assignment2 = Factory(:assignment, :store => @upitt, :employee => @terence, :start_date => 2.months.ago.to_date, :end_date =>1.month.ago.to_date, :pay_level => 1)
      #@assignment3 = Factory(:assignment, :store => @upitt, :employee => @kevin, :start_date => 5.months.ago.to_date, :end_date => nil, :pay_level => 3)
    
      @shift1 = Factory(:shift, :assignment => @assignment1, :date => Date.today, :start_time => Time.now, :end_time => nil, :notes => nil)
    end
    # and provide a teardown method as well
    teardown do
      @ed.destroy
      #@terence.destroy
      #@miko.destroy
      #@tom.destroy
      #@kevin.destroy
    
      @cmu.destroy
      #@upitt.destroy
      #@chartham.destroy
      
      @assignment1.destroy
      #@assignment2.destroy
      #@assignment3.destroy
      
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
