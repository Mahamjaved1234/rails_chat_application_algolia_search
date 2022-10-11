Rails.application.routes.draw do
  # require 'sidekiq/web'
  # Rails.application.routes.draw do
  #   mount Sidekiq::Web => '/sidekiq'
  # end
  resources :retailers
  resources :carts
  resources :orders
  resources :addresses
  resources :shoppers
  resources :subcategories
  resources :categories
  resources :brands
  resources :companies
  resources :products do
    collection do
      get :search
    end
  end
 # mount Base => "/api"
  # resources :session
  #  mount API::V1::Base => "/api/products"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html



  #GRAPE ROUTES: 
  mount API::Base => '/'


  #FOR API CALLS 
  namespace :api do 
  # mount Base => "/api"
  end
  # Defines the root path route ("/")
  get '/' => 'users#index' 

  # devise_for :users, controllers: {sessions: "sessions"}

#   devise_scope :user do
#     # Redirests signing out users back to sign-in
#     get "users/sign_out", to: "devise/sessions#destroy"
#     post "session/user", to: "devise/sessions#create"
#   end
# devise_for :users
post'/xyz' => 'xyz#index'

# post "welcome/trigger_job"

  # where visitor are redirected once job has been called
  # get "other/job_done"
end
