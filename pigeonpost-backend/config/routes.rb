Rails.application.routes.draw do

  get "api/auth", to: "application#auth"

  namespace :api do
    resources :users, only: [:index, :show, :create, :update]
    resources :drones, only: [:index, :show, :create, :update]
    resources :deliveries, only: [:index, :show, :create, :update]
    
    resources :contacts, only: [:create]
    delete "contacts", to: "contacts#destroy"
  end
end
