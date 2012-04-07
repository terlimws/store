Creamery2012::Application.routes.draw do

  resources :stores
  resources :employees
  resources :assignments
  resources :jobs
  resources :shifts
  resources :users
  resources :sessions
  
  # Authentication routes
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  # Semi-static page routes
  match 'home' => 'home#home', :as => :home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'privacy' => 'home#privacy', :as => :privacy
  match 'search' => 'home#search', :as => :search
  
  # Set the root url
  root :to => 'home#home'
  
end
