class User < ActiveRecord::Base
#  require 'bcrypt'
  
  # Relationships
  # -----------------------------
  belongs_to :employee
  
  # Scopes
  # -----------------------------
  
  # Validations
  # -----------------------------
end
