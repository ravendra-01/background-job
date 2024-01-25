Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # Defines the root path route ("/")
  # root "articles#index"
end
