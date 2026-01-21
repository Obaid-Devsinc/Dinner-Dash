Rails
  .application
  .routes
  .draw do
    devise_for :users

    root 'home#index'
    get 'home', to: 'home#index'

    resource :profile, only: %i[show edit update]
    resource :cart, only: [:show]
    resources :cart_items, only: %i[create update destroy]
    resources :orders, only: %i[index show create new]

    scope :admin do
      get 'dashboard', to: 'dashboard#index', as: :admin_dashboard
      resources :items, except: [:show]
      resources :categories, except: [:show]
      resources :orders, only: %i[index show] do
        member do
          patch :cancel
          patch :mark_paid
          patch :complete
        end
      end
    end
    
    resources :items, only: %i[index show]
    resources :categories, only: [:show]
  end
