class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end


  def edit
    @user = current_user
  end


  def create
    session[:user_id] = @user.id
    redirect_to home_path
  end


  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated #{@user.id}."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "Successfully removed #{@user.name} from the Creamery system."
      redirect_to users_url
  end
  
end
