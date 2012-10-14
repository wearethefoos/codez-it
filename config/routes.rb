require "#{Rails.root}/lib/mongoid/sluggable"

CodezIt::Application.routes.draw do

  devise_for :users

  resources :posts
  resources :accounts
  resources :authentications

  match "*path" => "posts#show", constraints: Mongoid::Sluggable::RedisRouter.new('Post')

  match '/auth/:provider/callback' => 'authentications#create'

  authenticated :user do
    root :to => "admin/accounts#index", :constraints => lambda { |req|
      req.session["warden.user.user.key"] &&
        User.where(_id: req.session["warden.user.user.key"][1]).count > 0 &&
        User.find(req.session["warden.user.user.key"][1]).first.admin
    }
  end

  constraints(Subdomain) do
    root :to => 'posts#index'
  end

  root :to => "home#index"
end
