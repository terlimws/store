class HomeController < ApplicationController
  
  def index
    render :action => params[:home]
  end

  def show
    render :action => params[:page_type]
  end

  def home
    if logged_in?
      if current_user.employee.role? :admin
        @stores = Store.paginate(:page => params[:page]).per_page(10)
      elsif current_user.employee.role? :manager
        #@employees = Employee.all
        @stores = Store.paginate(:page => params[:page]).per_page(10)
      end
    end
  end
  
end