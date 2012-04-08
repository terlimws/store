class Shift < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs
  has_one :store, :through => :assignment
  has_one :employee, :through => :assignment
  
  
  # Validations
  # -------------------
  # make sure required fields are present
  validates_presence_of :assignment_id, :date, :start_time
  
  # make sure assignment id is a positive integer
  validates_numericality_of :assignment_id, :only_integer => true, :greater_than => 0
  
  # ensure start time is before end time and not nil
  validates_time :start_time, :allow_nil => false
  
  # ensure end time is after start time
  validates_time :end_time, :after => :start_time, :allow_nil => true
  
  # Scopes
  # -----------------------------
  
  # returns all shifts in the system that have at least one job associated with them
  scope :completed, Shift.all.collect{|x| x if x.jobs.count >= 1}
  
  # returns all shifts in the sysem that do not have at least one job associated with them
  scope :incomplete, Shift.all.collect{|x| x if x.jobs.count < 1}
  
  # returns all shifts that are associated with a given store
  scope :for_store, lambda {|store_id| (Assignment.for_store(store_id).collect {|x| x.shifts}).flatten }
 
  # returns all shifts that are associated with a given employee
  scope :for_employee, lambda { |employee_id| Assignment.for_employee(employee_id).collect {|x| x.shifts}.flatten }
    
  # returns all shifts which have a date in the past
  scope :past, where('start_time < ?', Time.now.to_date)

  # returns all shifts which have a date in the present or future
  scope :upcoming, where('start_time >= ?', Time.now.to_date)
  
  # returns all shifts in the next 'x' days
  scope :for_next_days, lambda { |x|  Shift.find(:all, :conditions => [ "date <= ?", Date.today + x] ) }
    
  # returns all shifts in the previous 'x' days
  scope :for_past_days, lambda { |x|  Shift.find(:all, :conditions => [ "date <= ?", Date.today + x] ) }
  
  # returns all shifts chronologically
  scope :chronological, order('start_time, end_time')

  # returns shifts which orders values by store
  scope :by_store, (Assignment.by_store.collect {|x| x.shifts }).flatten

  
  # returns shifts which orders values by employee's last, first names
  #scope :by_employee, 
  
  
  # Methods
  # -----------------------------
  
  # returns true if the shift is currently active
  #def is_current
  #  return Time.now > start_time
  #end  
  
  # returns true if the shift has already ended
  #def has_ended
  #  return end_time < Time.now
  #end
  

  
end
