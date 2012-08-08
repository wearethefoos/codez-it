CodezIt::Application.routes.draw do

  resources :posts
  resources :accounts

  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications

  devise_for :users

  authenticated :user do
    root :to => "posts#index"
  end

  constraints(Subdomain) do
    match '/' => 'posts#index'
  end

  root :to => "home#index"
end
