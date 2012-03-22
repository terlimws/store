class Job < ActiveRecord::Base
  # Relationships
  # -----------------------------
  has_many :shift_jobs
  has_many :shifts, :through => :shift_jobs
  
  # Validations
  # -----------------------------

  # make sure required fields are present. jobs must have a name
  validates_presence_of :name
 
  # stores have job names which are unique in the system
  validates_uniqueness_of :name
  
  # Scopes
  # -----------------------------

  # returns all active jobs
  scope :active, where('active = ?', true)
  
  # returns all inactive jobs
  scope :inactive, where('active = ?', false)
  
  # orders results alphabetically
  scope :alphabetical, order('name')

end
