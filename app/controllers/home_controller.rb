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
        @top_5_employees = Employee.active.sort{|a,b| a.total_hours_in_x_days(14) <=> b.total_hours_in_x_days(14)}.first(5)
      elsif current_user.employee.role? :manager
        if current_user.employee.current_assignment == nil
          @employees = nil
          @shifts = nil
        else
          @employees = Employee.for_store(current_user.employee.current_assignment.store_id).where("end_date IS NULL").paginate(:page => params[:page]).per_page(10)
          @shifts = Shift.for_store(current_user.employee.current_assignment.store_id).for_next_days(0).chronological
          @incomplete_shifts = Shift.past.incomplete
        end
      end
    end
  end
  
  def search
    @query = params[:query]
    if logged_in?
      if current_user.employee.role? :admin
        @employees = Employee.search(@query)
      else current_user.employee.role? :manager
        @employees = Employee.for_store(current_user.employee.current_assignment.store_id).search(@query)
      end
    @totalhits = @employees.size
    end
  end
  
end