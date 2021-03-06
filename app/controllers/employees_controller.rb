class EmployeesController < ApplicationController

  before_filter :check_login
  authorize_resource
  
  def index
    if current_user.employee.role? :admin
      @employees = Employee.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    elsif current_user.employee.role? :manager
      @employees = Employee.active.for_store(current_user.employee.current_assignment.store.id).where('end_date IS NULL').paginate(:page => params[:page]).per_page(10)
    else
      @employees = nil
    end
  end
  
  def inactive
    if current_user.employee.role? :admin
      @employees = Employee.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    else
      @employees = nil
    end
  end

  def show
    @employee = Employee.find(params[:id])
    authorize! :read, @employee
  end

  def new
    @employee = Employee.new
    authorize! :create, @employee
  end

  def edit
    @employee = Employee.find(params[:id])
    
    # Handle shortcut deactivations
    unless params[:status].nil?
      if params[:status].match(/deactivate/) # == 'deactivate_prj' || params[:status] == 'deactivate_asgn'
        @employee.update_attribute(:active, false)
        flash[:notice] = "#{@employee.name} was made inactive."
      elsif params[:status].match(/activate/) # == 'activate_prj' || params[:status] == 'activate_asgn'
        @employee.update_attribute(:active, true)
        flash[:notice] = "#{@employee.name} was made active."
      end
      redirect_to employees_path if params[:status].match(/_employee/)
    end
    
    authorize! :update, @employee
  end

  def create
    @employee = Employee.new(params[:employee])
    if @employee.save
      # if saved to database
      flash[:notice] = "Successfully created #{@employee.name}."
      redirect_to @employee # go to show employee page
    else
      # return to the 'new' form
      render :action => 'new'
    authorize! :create, @employee
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
