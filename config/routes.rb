Rails.application.routes.draw do
  devise_for :users

  root "home#index"
  get "home", to: "home#index"

  resource :profile, only: [ :show, :edit, :update ]
  resources :items, only: [ :index, :show ]
  resources :categories, only: [ :show ]
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]
  resources :orders, only: [ :index, :show, :create, :new ]

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :items, except: [ :show ]
    resources :categories, except: [ :show ]
    resources :orders, only: [ :index, :show ] do
      member do
        patch :cancel
        patch :mark_paid
        patch :complete
      end
   end
  end
end
