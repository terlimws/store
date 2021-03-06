class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      
      if user.employee.nil?
        can :read, Store
        cannot :manage, User
      
      else
      
        if user.employee.role? :admin
          can :manage, :all
          
        elsif user.employee.role? :manager
          can :manage, Shift do |shift|
            if shift.assignment != nil
              user.employee.current_assignment.store_id == shift.assignment.store_id 
            else
              true
            end
          end
          
          can :read, Store
          can :update, Employee do |employee|
            employee.current_assignment.store_id == user.employee.current_assignment.store_id
          end
          can :read, Employee do |employee|
            employee.current_assignment.store_id == user.employee.current_assignment.store_id
          end
          cannot :manage, User
          
        elsif user.employee.role? :employee
          can :read, Store
          can :read, Shift do |shift|
            shift.assignment.employee_id == user.employee.id
          end
          cannot :manage, User
        end
      end
        
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
