Rails.application.routes.draw do
  get "dashboard/index"
  get "profiles/index"
  get "profiles/edit"
  get "profiles/update"
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
  # resources :branches
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
  
  Rails.application.routes.draw do
  get "dashboard/index"
    namespace :api do
      namespace :v1 do
        resources :credit_cards do
         member do
          patch :restore
          patch :discard
         end
        end
      end 
    end
  end

  Rails.application.routes.draw do
  get "dashboard/index"
    namespace :api do
      namespace :v1 do
        resources :customers, params: :customer_id
        resources :credit_cards, params: :credit_card_id
        resources :account_transactions, params: :transaction_id
        resources :branches, params: :branch_id
        resources :rewards, params: :reward_id
        resources :user_cards, params: :user_card_id
      end
    end
  end

  Rails.application.routes.draw do
  get "dashboard/index"
    namespace :api do
      namespace :v1 do
        post 'auth/login', to: 'auth#create'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :frontend_user_cards, only: [:index]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :frontend_account_transactions, only: [:index, :create]
    end
  end

    namespace :api do
      namespace :v1 do
        resource :frontend_profile, only: [:show, :update]
      end
    end
  

    get 'dashboard', to: 'dashboard#index'


end
