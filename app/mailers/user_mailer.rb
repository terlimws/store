class UserMailer < ActionMailer::Base
  default from: "terlimws@gmail.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
  
  def test_mail
    mail :to => "terlimws@gmail.com", :subject => "hey"
  end
end

