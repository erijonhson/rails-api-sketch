require 'api_version_constraint'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      resources :tasks # api.rails-api-sketch.dev/tasks
    end

    # TODO create folder api/v2 for other api version
    #namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2) do
    #  resources :whatever # api.rails-api-sketch.dev/whatever
    #end
  end

  # TODO add host api.rails-api-sketch.dev to 127.0.1.1 on the OS on which server was deployed 

end
