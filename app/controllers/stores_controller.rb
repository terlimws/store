class StoresController < ApplicationController

  before_filter :check_login, :except => [:index, :show]
  authorize_resource

  def index
    @stores = Store.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @map = Cartographer::Gmap.new( 'map' )
    @map.zoom = :bound
    @icon = Cartographer::Gicon.new()
    @map.icons <<  @icon
    
    marker_index = 1
    
    @stores.each { |store| marker = Cartographer::Gmarker.new(:name=> "store",
                 :position => [store.latitude, store.longitude],
                :icon => @icon, :click => "alert('Store Name: #{store.name}');")
      @map.markers << marker
    }
  end

  def show
    @store = Store.find(params[:id])
    authorize! :read, @store
    
    @map = Cartographer::Gmap.new( 'map' )
    @icon = Cartographer::Gicon.new()
    @map.icons <<  @icon
    
    marker_index = 1
    
    marker = Cartographer::Gmarker.new(:name=> "store",
                 :position => [@store.latitude, @store.longitude],
                :icon => @icon, :click => "alert('#{@store.name}');")
    
    @map.markers << marker
    @map.zoom = :bound
    
  end
  
  def inactive
    @stores = Store.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def new
    @store = Store.new
  end

  def edit
    @store = Store.find(params[:id])

    # Handle shortcut deactivations
    unless params[:status].nil?
      if params[:status].match(/deactivate/) # == 'deactivate_prj' || params[:status] == 'deactivate_asgn'
        @store.update_attribute(:active, false)
        flash[:notice] = "#{@store.name} was made inactive."
      elsif params[:status].match(/activate/) # == 'activate_prj' || params[:status] == 'activate_asgn'
        @store.update_attribute(:active, true)
        flash[:notice] = "#{@store.name} was made active."
      end
      redirect_to stores_path if params[:status].match(/_store/)
    end
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
