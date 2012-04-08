class User < ActiveRecord::Base
  has_secure_password
  
  attr_accessible :email, :password, :password_confirmation, :employee_id, :role
#  require 'bcrypt'
  
  # Relationships
  # -----------------------------
  belongs_to :employee
  #has_one :employee
  
  # Scopes
  # -----------------------------
  
  # Validations
  # -----------------------------
  
  
  def self.authentication(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  
end
