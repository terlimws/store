class ShiftsController < ApplicationController
  
  before_filter :check_login
  authorize_resource
  
  def index
    @shifts = Shift.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @shift = Shift.find(params[:id])
  end

  def new
    @shift = Shift.new
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      # if saved to database
      flash[:notice] = "Successfully created shift for #{@shift.id}."
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
