class ShiftJob < ActiveRecord::Base
  # Relationships
  # -----------------------------
  belongs_to :shift
  belongs_to :job
  
  
  # Validations
  # -----------------------------
  # make sure required fields are present. Assignments have a store id, employee id, valid start date, and valid pay level (via validates_numericality_of)
  validates_presence_of :job_id, :shift_id  
  

  # Scopes
  # -----------------------------
  
  ## returns all assignments that are associated with a given job (parameter: job_id)
  #scope :for_job, lambda {|employee_id| where("job_id = ?", job_id) }
  #
  ## returns all assignments that are associated with a given shift (parameter: shift_id)
  #scope :for_shift, lambda {|store_id| where("shift_id = ?", shift_id) }
  
  
  # Use private methods to execute the custom validations
  # -----------------------------
  
  # checks if jobs are active and in the system for new assignments
  #private
  #def job_is_active_in_creamery_system
  #  # get an array of all active jobs in the system
  #  all_job_ids = Job.active.all.map{|o| o.id}
  #  unless all_job_ids.include?(self.job_id)
  #    errors.add(:job, "is not an active job in Creamery")
  #    return false
  #  end
  #  return true
  #end
  
end