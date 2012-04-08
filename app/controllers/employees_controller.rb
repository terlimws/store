class EmployeesController < ApplicationController

  before_filter :check_login
  authorize_resource
  
  def index
    @employees = Employee.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      puts "\n\n\n\n\n\n\n\n\nSuccesss!"
      # if saved to database
      flash[:notice] = "Successfully created #{@employee.name}."
      redirect_to @employee # go to show employee page
    else
      puts "\n\n\n\n\n\n\n\n\nFailed!"
      # return to the 'new' form
      render :action => 'new'
    end

  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated #{@employee.name}."
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end

  def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      flash[:notice] = "Successfully removed #{@employee.name} from the Creamery system."
      redirect_to employees_url
  end
  
end
