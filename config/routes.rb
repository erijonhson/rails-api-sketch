require 'api_version_constraint'

# TODO add host api.rails-api-sketch.dev to 127.0.1.1 on the OS on which server was deployed 
Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy] # api.rails-api-sketch.dev/users
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update]
    end

    # TODO create folder api/v2 for other api version
    #namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2) do
    #  resources :whatever # api.rails-api-sketch.dev/whatever
    #end
  end

end
