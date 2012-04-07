class UserController < ApplicationController
  
  def new
    @user = User.new
  end


  def edit
    @employee = current_user
  end


  def create
    session[:user_id] = @user.id
    redirect_to home_path
  end


  def update
    @employee = current_user
  end
  

end
