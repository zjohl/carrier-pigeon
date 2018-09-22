Rails.application.routes.draw do

  namespace :api do
    resources :users, only: [:index, :show, :create, :update]
    resources :drones, only: [:index, :show, :create, :update]
  end
end
