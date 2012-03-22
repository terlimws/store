class Shift < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, :through => :shift_jobs
  
  
  # Validations
  # -----------------------------
  # make sure required fields are present. Shifts have an assignment_id, date and start_time
  validates_presence_of :assignment_id, :date, :start_time
  
  
  
  # Scopes
  # -----------------------------
  
  # returns all shifts starting in a week
  
  # returns all shifts that are associated with a given employee (parameter: employee_id)
  scope :for_employee, lambda {|employee_id| joins(:assignment).where("employee_id = ?", employee_id) }

  # orders shifts by start_time
  scope :by_start_time, order('start_time')
  
  # returns all the shifts that are considered current
  #scope :current, where("? > Time.now", end_time)

  # returns all the past/expired shifts for auditing purposes
  #scope :expired, where("? < Time.now", end_time)
  
  
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
