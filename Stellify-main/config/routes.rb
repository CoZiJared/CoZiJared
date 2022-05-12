Rails.application.routes.draw do
  devise_scope :user do
    get "/logged_in", to: "users/sessions#logged_in"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: { sessions: "users/sessions" }
  # Defines the root path route ("/")
  root "users#explore"

  get "likes", to: "users#index"

  get "like/:user_id", to: "user_likes#like", as: "like"

  resources :users, only: %i[show index]
end
