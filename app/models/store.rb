class Store < ActiveRecord::Base
  
  attr_accessible :create_active_stores_map_link
  
  # Callbacks
  before_save :reformat_phone
  #before_save :find_store_coordinates
  
  # Relationships
  has_many :assignments
  has_many :employees, :through => :assignments
  has_many :shifts, :through => :assignments
  
  
  # Validations
  # -----------------------------
  # make sure required fields are present. stores must have a name, street, and zip code
  validates_presence_of :name, :street, :zip
  
  # make sure stores have values which are the proper data type and within proper ranges
  # if zip included, it must be 5 digits only
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  
  #validates_format_of :city, :with => /[a-zA-Z]/, :message => "should be only alphabets", :allow_nil => true, :allow_blank => true
  
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], :message => "is not an option", :allow_nil => true, :allow_blank => true
  
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  # stores have phone values that are saved in the system as a string of digits (no other characters allowed in db, but user may input values with dashes)
  #validates_format_of :phone, :with => /^(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
  validates_format_of :phone, :with => /^\d{3}[- ]?\d{3}[- ]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
  
  # stores have store names which are unique in the system
  validates_uniqueness_of :name
  
  # stores have phone numbers which are unique in the system
  validates_uniqueness_of :phone
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  
  def create_map_link(zoom=13,width=400,height=400)
    map = "http://maps.google.com/maps/api/staticmap?center=#{latitude},#{longitude}&zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap&markers=color:red%7Ccolor:red%7C#{latitude},#{longitude}&sensor=false"
  end
  
  def create_active_stores_map_link(zoom=13,width=400,height=400)
    markers = ''
    i = 1
    Store.active.each do |store|
      markers += "&markers=color:red%7Ccolor:red%7Clabel:#{i}%7C#{store.latitude},#{store.longitude}"
      i += 1
    end
    map = "http://maps.google.com/maps/api/staticmap?zoom=#{zoom}&size=#{width}x#{height}&maptype=roadmap#{markers}&sensor=false"
  end
  
  def total_hours_in_x_days(days=14)
    hours = 0
    self.shifts.for_next_days(days).each {|shift| hours += shift.total_hours}
    return hours
  end
  
  # Callback code
  # -----------------------------
   private
   # We need to strip non-digits before saving to db
   def reformat_phone
     phone = self.phone.to_s  # change to string in case input as all numbers 
     phone.gsub!(/[^0-9]/,"") # strip all non-digits
     self.phone = phone       # reset self.phone to new string
   end
   
  def find_store_coordinates
    coord = Geokit::Geocoders::GoogleGeocoder.geocode "#{street}, #{city}, #{state}, #{zip}"
    if coord.success
      self.latitude, self.longitude = coord.ll.split(',')
    else
      errors.add :base, "Error with geocoding"
    end
  end

end
