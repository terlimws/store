class Shift < ActiveRecord::Base
  # callbacks
  before_create :generate_end_time
  
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
  scope :completed, where(:id => ShiftJob.select('shift_id'))
  
  # returns all shifts in the sysem that do not have at least one job associated with them
  scope :incomplete, where('shifts.id NOT IN (SELECT shift_id FROM shift_jobs)')
  
  # returns all shifts that are associated with a given store
  scope :for_store, lambda {|store_id| joins(:assignment).where('store_id = ?', store_id) }
 
  # returns all shifts that are associated with a given employee
  scope :for_employee, lambda { |employee_id| joins(:assignment).where('employee_id = ?', employee_id) }
  
  # returns all shifts that are associated with a given assignment
  scope :for_assignment, lambda {|assignment_id| where("assignment_id = ?", assignment_id) }
    
  # returns all shifts which have a date in the past
  scope :past, where('date < ?', Date.today)

  # returns all shifts which have a date in the present or future
  scope :upcoming, where('date >= ?', Date.today)
  
  # returns all shifts in the next 'x' days
  scope :for_next_days, lambda { |x| where('date BETWEEN :start_date AND :end_date', start_date:DateTime.now, end_date:x.days.from_now) }
    
  # returns all shifts in the previous 'x' days
  scope :for_past_days, lambda { |x| where('date BETWEEN :start_date AND :end_date', start_date:x.days.ago-1.day, end_date:DateTime.now-1.day) }
  
  # returns all shifts chronologically
  scope :chronological, order('date, start_time, end_time')

  # returns shifts which orders values by store
  scope :by_store, joins(:store).order('name')

  # returns shifts which orders values by employee's last, first names
  scope :by_employee, joins(:employee).order('last_name, first_name')

  # return all shifts that has ended
  scope :ended_shifts, where('end_time < ?', Time.now)
  
  
  # Methods
  # -----------------------------
  
  def completed?
    # get an array of all shifts in the shiftjob table
    possible_shift_ids = ShiftJob.all.shift_id.map{|s| s.id}.compact!
    # return true if shift id is in the array
    if possible_shift_ids.contains(self.id)
      return true
    end
  end

  def active?
    return self.end_time == nil?
  end

  # returns true if the shift is currently active
  def is_current
    date == Date.today && end_time > Time.now
  end  
  
  # returns true if the shift has already ended
  def has_ended
    if date < Date.today
      return true
    else
      return end_time < Time.now
    end
  end
  
  private
  #check if assignment is current
  def assignment_is_current
    current_assignments_id = Assignment.current.all.map{|x| x.id}
    unless assignment_is_current.include?(self.assignment_id)
      errors.add(:assignment_id, "is not current")
    end
  end
  
  def generate_end_time
    self.end_time = self.start_time + 3.hours if self.end_time.blank?
  end
end
