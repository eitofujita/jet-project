Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "feeds#show"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"

  resources :users, only: %i[index show] do
    resource :follow, only: %i[create destroy]
    member do
      get :followers
      get :following
    end
  end

  resources :posts do
    resources :comments, only: %i[create destroy]
    resource :like, only: %i[create destroy]
  end

  resource :feed, only: :show
end
