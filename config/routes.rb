CodezIt::Application.routes.draw do

  devise_for :users

  resources :posts
  resources :accounts

  match "*path" => "posts#show", constraints: Mongoid::Sluggable::RedisRouter.new('Post')

  match '/auth/:provider/callback' => 'authentications#create'

  resources :authentications

  constraints(Subdomain) do
    root :to => 'posts#index'
  end

  authenticated :user do
    root :to => "admin/accounts#index", :constraints => lambda{ |req| User.find(req.session["warden.user.user.key"][1]).first.admin }
    #root :to => "posts#index", :constraints => lambda{ |req| User.find(req.session["warden.user.user.key"][1]).first.account }
  end

  root :to => "home#index"
end
