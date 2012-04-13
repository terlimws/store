class ShiftsController < ApplicationController
  
  before_filter :check_login
  authorize_resource
  
  def index
    if current_user.employee.role == 'manager'
      @shifts = Shift.for_store(current_user.employee.current_assignment.store_id).paginate(:page => params[:page]).per_page(10)
    else
      @shifts = Shift.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @shift = Shift.find(params[:id])
  end


  def new
    if params[:assignment_id]
      @shift = Shift.new(:assignment_id => params[:assignment_id])
      @shift.shift_jobs.build
    else
      @shift = Shift.new
    end
    authorize! :create, @shift
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def create
    @shift = Shift.new(params[:shift])
    
    if @shift.save
      # if saved to database
      flash[:notice] = "Successfully created shift for #{@shift.employee.name}."
      redirect_to @shift # go to show shift page
    else
      # return to the 'new' form
      render :action => 'new'
    end

  end

  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(params[:shift])
      flash[:notice] = "Successfully updated #{@shift.id}."
      redirect_to @shift
    else
      render :action => 'edit'
    end
  end

  def destroy
      @shift = Shift.find(params[:id])
      @shift.destroy
      flash[:notice] = "Successfully removed #{@shift.id} from the Creamery system."
      redirect_to shifts_url
  end
  
end
