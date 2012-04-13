class JobsController < ApplicationController
  
  before_filter :check_login
  authorize_resource
  
  def index
    @jobs = Job.active.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def inactive
    @jobs = Job.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
    
    # Handle shortcut deactivations
    unless params[:status].nil?
      if params[:status].match(/deactivate/) # == 'deactivate_prj' || params[:status] == 'deactivate_asgn'
        @job.update_attribute(:active, false)
        flash[:notice] = "#{@job.name} was made inactive."
      elsif params[:status].match(/activate/) # == 'activate_prj' || params[:status] == 'activate_asgn'
        @job.update_attribute(:active, true)
        flash[:notice] = "#{@job.name} was made active."
      end
      redirect_to jobs_path if params[:status].match(/_job/)
    end
  end

  def create
    @job = Job.new(params[:job])
    if @job.save
      # if saved to database
      flash[:notice] = "Successfully created #{@job.name}."
      redirect_to @job # go to show job page
    else
      # return to the 'new' form
      render :action => 'new'
    end

  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = "Successfully updated #{@job.name}."
      redirect_to @job
    else
      render :action => 'edit'
    end
  end

  def destroy
      @job = Job.find(params[:id])
      @job.destroy
      flash[:notice] = "Successfully removed #{@job.name} from the Creamery system."
      redirect_to jobs_url
  end
  
end
