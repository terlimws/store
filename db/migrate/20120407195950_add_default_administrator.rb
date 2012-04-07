class AddDefaultAdministrator < ActiveRecord::Migration
  def up
    admin = User.new
    admin.email = "terlimws@gmail.com"
    admin.password = "1234"
    admin.password_confirmation = "1234"
    admin.employee_id = "110"
    admin.save!
  end

  def down
    admin = User.find_by_email "terlimws@gmail.com"
    User.delete admin
  end
end
