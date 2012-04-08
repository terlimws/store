class StoresController < ApplicationController

  before_filter :check_login
  authorize_resource

  def index
    @stores = Store.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find(params[:id])
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      # if saved to database
      flash[:notice] = "Successfully created #{@store.name}."
      redirect_to @store # go to show owner page
    else
      # return to the 'new' form
      render :action => 'new'
    end

  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      flash[:notice] = "Successfully updated #{@store.name}."
      redirect_to @store
    else
      render :action => 'edit'
    end
  end

  def destroy
      @store = Store.find(params[:id])
      @store.destroy
      flash[:notice] = "Successfully removed #{@store.name} from the Creamery system."
      redirect_to stores_url
  end

end
