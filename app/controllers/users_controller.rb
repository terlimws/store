class UsersController < ApplicationController
  before_filter :check_login
  authorize_resource
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end


  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end


  def create
    if current_user.employee.role? :admin
      @user = User.new(params[:user])
      @user.password = params[:password]
      if @user.save
        # if saved to database
        flash[:notice] = "Successfully created User Account for #{@user.employee.name}."
        redirect_to @user # go to show employee page
      else
        # return to the 'new' form
        render :action => 'new'
      end
    else
      session[:user_id] = @user.id
      redirect_to home_path
    end
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User Account for #{@user.employee.name}."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "Successfully removed User Account for #{@user.employee.name} from the Creamery system."
      redirect_to users_url
  end
  
end
