# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root "tasks#index"

  get "tasks/index"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/user_profile", to: "users#edit"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/passwords/reset", to: "passwords#new"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :users, except: [ :index, :show, :edit ]
  resources :passwords, param: :token
end
