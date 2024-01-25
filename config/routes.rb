Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # Defines the root path route ("/")
  root "users#index"

  resources :users, only: [:index, :destroy]
end
