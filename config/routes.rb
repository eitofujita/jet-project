Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "feeds#show"

  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create show] do
    resource :follow, only: %i[create destroy]
  end

  resources :posts do
    resources :comments, only: %i[create destroy]
    resource :like, only: %i[create destroy]
  end

  resource :feed, only: :show
end
