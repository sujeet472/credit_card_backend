Rails.application.routes.draw do
  # Devise
  devise_for :users

  # Custom authentication
  post '/auth/login', to: 'authentication#login'

  # Public routes
  get 'home/index'
  get 'dashboard/index'
  get 'dashboard', to: 'dashboard#index'

  # Profiles
  resources :profiles do
    collection do
      get :index
      get :show
      get :new
      get :create
      get :edit
      get :update
      get :destroy
    end
  end

  # Credit cards
  resources :credit_cards do
    collection do
      get :index
    end
  end

  # Root route
  root to: "branches#index"

  # Soft-deletable resources
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

  # API Namespaces
  namespace :api do
    namespace :v1 do
      resources :credit_cards do
        member do
          patch :restore
          patch :discard
        end
      end

      resources :profiles, params: :profile_id
      resources :account_transactions, params: :transaction_id
      resources :branches, params: :branch_id
      resources :rewards, params: :reward_id
      resources :user_cards, params: :user_card_id

      post 'auth/login', to: 'auth#create'

      resources :frontend_user_cards, only: [:index]
      resources :frontend_account_transactions, only: [:index, :create]
      resource :frontend_profile, only: [:show, :update]
    end
  end

  # Health & PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
