source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'rake','10.0.3'
gem 'wicked_pdf'

#gem 'mysql2'
gem 'devise'
gem 'devise_invitable'
gem 'simple_form'
gem 'exception_notification'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "twitter-bootstrap-rails"
  gem "therubyracer"
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
end

gem "rspec-rails", "~> 2.0", :group => [:test, :development]

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9'
  gem "database_cleaner"
  gem "email_spec"
  gem "cucumber-rails", :require => false
  gem 'guard-cucumber'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'sqlite3'
end

gem 'jquery-rails'
gem "rails_config"
gem "rolify"
gem 'fog'
gem "cancan", ">= 1.6.8"
gem "carrierwave"


gem 'whenever', :require => false

#gem "eventmachine" WIll be awesome to get live status of server
# To use ActiveModel has_secure_password
