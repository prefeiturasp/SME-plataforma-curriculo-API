source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.10'

# Added because of the ActiveAdmin
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use jquery as the javascript library
gem 'jquery-rails'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# listen check modifications in app directories
gem 'listen', '>= 3.0.5', '< 3.2'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring'
gem 'spring-watcher-listen', '~> 2.0.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'faker'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
gem 'image_processing', '~> 1.2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock'
end

group :development do
  gem 'capistrano', '~> 3.11.0'
  gem 'capistrano-rails'

  gem 'rubocop', require: false
end

# Admin area
gem 'activeadmin', '~> 1.3.0'
gem 'activeadmin_addons', '~> 1.6.0'
gem 'activeadmin-xls', '~>2.0.0'

# authentication solution for Rails based on Warden
gem "devise", '~> 4.4.3'
gem 'devise-jwt'

# gem 'devise_saml_authenticatable', '~>1.4.1'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ActiveAdmin Quill Editor
gem 'activeadmin_quill_editor', '~> 0.1.4'

# Pretty URLs and work with human-friendly strings
gem 'friendly_id', '~> 5.2.4', github: 'norman/friendly_id'

# Pagination library
gem 'kaminari'

# Paginate in your headers
gem 'api-pagination'

# Intelligent search made easy with Rails and Elasticsearch
gem 'searchkick'

# Access your external REST API
gem 'flexirest', '~> 1.7.5'
gem 'httparty'

# Use CarrierWave to provide a simple and extremely flexible way to upload files
gem 'carrierwave', '~> 2.0'

# Validate admin permitions
gem 'cancancan'
