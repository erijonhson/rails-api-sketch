
Rails.application.routes.draw do

  namespace :api, defaults: { format: :json }, path: '/api' do
    namespace :v1, path: '/v1' do
      devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

      resources :users, only: [:show, :create, :update, :destroy] # api.rails-api-sketch.dev/users
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end

    namespace :v2, path: '/v2' do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: [:show, :create, :update, :destroy] # api.rails-api-sketch.dev/users
      resources :sessions, only: [:create, :destroy]
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
    end
  end

end
