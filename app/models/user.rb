require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password
  before_create { generate_token(:auth_token) }
  
  # attr_accessible :email, :password, :password_confirmation
  #:employee_id, :role
  include BCrypt
  
  # Relationships
  # -----------------------------
  belongs_to :employee
  
  # Scopes
  # -----------------------------
  
  # Validations
  # -----------------------------
  # Validations
  # make sure required fields are present
  validates_presence_of :employee_id, :email, :password_digest
  # make sure format of email recognized
  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, :message => "email format unrecognized"
  # make sure email is unique
  validates_uniqueness_of :email
  # make sure employee_id belongs to active employee
  validate :employee_is_active_in_system
  
  
  def self.authentication(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    #self.password_reset_token = 1234
    self.password_reset_sent_at = Time.now
    save!
    UserMailer.password_reset(self).deliver
  end


  private
  def employee_is_active_in_system
    all_active_employees = Employee.active.all.map{|e| e.id}
    unless all_active_employees.include?(self.employee_id)
      errors.add(:employee_id, "is not an active employee at the creamery")
    end
  end
  
end
