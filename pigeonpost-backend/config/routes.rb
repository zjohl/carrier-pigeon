Rails.application.routes.draw do

  get "api/auth", to: "application#auth"

  namespace :api do
    resources :users, only: [:index, :show, :create, :update]
    resources :drones, only: [:index, :show, :create, :update]

    get "deliveries/search", to: "deliveries#index_by_user_and_status"
    resources :deliveries, only: [:index, :show, :create, :update]
    
    resources :contacts, only: [:create]
    delete "contacts", to: "contacts#destroy"
  end
end
