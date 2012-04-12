class ShiftJob < ActiveRecord::Base
  
  belongs_to :shift
  belongs_to :job
  
  # make sure required fields are present. shift_job should have shift_id and job_id
  validates_presence_of :shift_id, :job_id
  validate :shift_ended

  private
  def shift_ended
    completed_shifts_id = Shift.all.map {|x| x.id if x.is_current==false}
    unless completed_shifts_id.include?(self.shift_id)
      errors.add(:shift_id, "has not ended")
    end
  end
  
end