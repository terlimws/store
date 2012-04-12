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
        if current_user.employee.current_assignment == nil
          @employees = nil
          @shifts = nil
        else
          @employees = Employee.for_store(current_user.employee.current_assignment.store_id).paginate(:page => params[:page]).per_page(10)
          @shifts = Shift.for_store(current_user.employee.current_assignment.store_id).for_next_days(0).chronological
        end
      end
    end
  end
  
end