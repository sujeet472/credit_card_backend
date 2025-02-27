Rails.application.routes.draw do
  get "credit_cards/index"
  get "home/index"
  devise_for :users

  # resources :users
  post '/auth/login', to: 'authentication#login'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # root to: "home#index"
  resources :branches
  root to: "branches#index" 

  resources :branches do
    member do
      patch :restore
    end
  end

  
  resources :account_transactions do
    member do
      patch :undiscard
    end
  end

  resources :rewards do
    member do
      patch :undiscard
    end
  end

  resources :user_cards do
    member do
      patch :restore
    end
  end

  resources :credit_cards 
  
end
