require 'api_version_constraint'

# TODO add host api.rails-api-sketch.dev to 127.0.1.1 on the OS on which server was deployed
Rails.application.routes.draw do

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: false) do
      devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

      resources :users, only: [:show, :create, :update, :destroy] # api.rails-api-sketch.dev/users
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end

    namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: [:show, :create, :update, :destroy] # api.rails-api-sketch.dev/users
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end
  end

end
