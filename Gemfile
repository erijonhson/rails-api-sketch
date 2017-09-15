source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5' # https://github.com/rspec/rspec-rails
end

group :test do
  gem 'database_cleaner' # https://github.com/DatabaseCleaner/database_cleaner
  gem 'shoulda-matchers', '~> 3.1' # https://github.com/thoughtbot/shoulda-matchers
  gem 'factory_girl_rails' # https://github.com/thoughtbot/factory_girl_rails
  gem 'faker' # https://github.com/stympy/faker
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise' # https://github.com/plataformatec/devise
gem 'active_model_serializers', '~> 0.10.0' # https://github.com/rails-api/active_model_serializers/tree/0-10-stable
gem 'ransack' # https://github.com/activerecord-hackery/ransack
gem 'omniauth' # https://github.com/omniauth/omniauth
gem 'devise_token_auth' # https://github.com/lynndylanhurley/devise_token_auth
