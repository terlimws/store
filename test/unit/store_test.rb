require 'test_helper'

class StoreTest < ActiveSupport::TestCase
  # Relationship macros...
  should have_many(:assignments)
  should have_many(:employees).through(:assignments)
  
  # Validation macros...
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:zip)
  
  
  # Validating zip...
  should allow_value("03431").for(:zip)
  should allow_value("15217").for(:zip)
  should allow_value("15090").for(:zip)
  
  should_not allow_value("fred").for(:zip)
  should_not allow_value("3431").for(:zip)
  should_not allow_value("15213-9843").for(:zip)
  should_not allow_value("15d32").for(:zip)
  should_not allow_value(nil).for(:zip)
  
  # Validating phone...
  should allow_value("4128054522").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should_not allow_value("412.268.3259").for(:phone)
  should_not allow_value("(412) 268-3259").for(:phone)
  
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  # Validating state...
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value("CA").for(:state)
  
  # ---------------------------------
  # Testing other methods with a context
  context "Creating three stores" do
    # create the objects I want with factories
    setup do
      @cmu = Factory.create(:store, :latitude => 40.4435037, :longitude => -79.9415706)
      @upitt = Factory.create(:store, :name => "UPitts", :street => "5002 Fifth Avenue", :city => "Pittsburgh", :state => "PA", :zip => "15210", :phone => "1234567289", :active => true)
      @chartham = Factory.create(:store, :name => "Chartham", :street => "5020 Fifth Avenue", :city => "Pittsburgh", :state => "PA", :zip => "15223", :phone => "193-553-2235", :active => false)
    end
    
    # and provide a teardown method as well
    teardown do
      @cmu.destroy
      @upitt.destroy
      @chartham.destroy
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    should "show that all factories are properly created" do
      assert_equal "CMU", @cmu.name
      assert_equal "UPitts", @upitt.name
      assert_equal "Chartham", @chartham.name
      assert @cmu.active
      assert @upitt.active
      deny @chartham.active
    end
    
    # test the scope 'alphabetical'
    should "shows that there are three stores in alphabetical order" do
      #assert_equal ["CMU", "Chartham", "UPitts"], Store.alphabetical.map{|o| o.name}
      assert_equal ["CMU", "Chartham", @upitt.name], Store.alphabetical.map{|o| o.name}
    end
    
    # test the scope 'active'
    should "shows that there are two active stores" do
      assert_equal 2, Store.active.size
      assert_equal ["CMU", "UPitts"], Store.active.alphabetical.map{|o| o.name}
    end
    
    # test the scope 'inactive'
    should "shows that there are one inactive stores" do
      assert_equal 1, Store.inactive.size
      assert_equal ["Chartham"], Store.inactive.alphabetical.map{|o| o.name}
    end
    
    # test for uniqueness of name
    should "not allow repetition of store name" do
      cmu_again = Factory.build(:store, :name => "CMU")
      deny cmu_again.valid?
    end
    
    # test for uniqueness of phone
    should "not allow repetition of store's phone" do
      phone_again = Factory.build(:store, :name => "ABC", :phone => "1234567289")
      deny phone_again.valid?
    end    
    
    # test the method total_hours_in_x_days'
    should "shows that total hours in CMU store is 0" do
      assert_equal 0, @cmu.total_hours_in_x_days(14)
    end
    
    # test the method create_map_link'
    should "shows that the map link is given" do
      assert_equal "http://maps.google.com/maps/api/staticmap?center=40.4435037,-79.9415706&zoom=13&size=400x400&maptype=roadmap&markers=color:red%7Ccolor:red%7C40.4435037,-79.9415706&sensor=false", @cmu.create_map_link(13,400,400)
    end
    
    # test the method create_active_stores_map_link'
    should "shows that the full stores map link is given" do
      assert_equal "http://maps.google.com/maps/api/staticmap?zoom=13&size=400x400&maptype=roadmap&markers=color:red%7Ccolor:red%7Clabel:1%7C40.4435037,-79.9415706&markers=color:red%7Ccolor:red%7Clabel:2%7C12.235,52.325&sensor=false", Store.create_active_stores_map_link(13,400,400)
    end
    
    # test the callback is working 'reformat_phone'
    should "shows that Chartham's phone is stripped of non-digits" do
      assert_equal "1935532235", @chartham.phone
    end
    

  
  end
end
