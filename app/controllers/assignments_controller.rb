class AssignmentsController < ApplicationController
  
  before_filter :check_login
  authorize_resource  
  
  def index
    @assignments = Assignment.current.paginate(:page => params[:page]).per_page(10)
    @past_assignments = Assignment.past.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @assignment = Assignment.find(params[:id])
  end

  def new
    if params[:store_id]
      @assignment = Assignment.new(:store_id => params[:store_id])
    else
      @assignment = Assignment.new
    end
    authorize! :create, @assignment
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      # if saved to database
      flash[:notice] = "Successfully created assignment for #{@assignment.employee.name}."
      redirect_to @assignment # go to show assignment page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated assignment for #{@assignment.employee.name}."
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end

  def destroy
      @assignment = Assignment.find(params[:id])
      @assignment.destroy
      flash[:notice] = "Successfully removed #{@assignment.employee.name}'s assignment from the Creamery system."
      redirect_to assignments_url
  end


  
end
