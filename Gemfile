source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# ActiveLdap for communication with LDAP
gem 'activeldap', require: 'active_ldap/railtie'
gem 'net-ldap', '~> 0.11'
gem "devise_ldap_authenticatable", :git => "git://github.com/cschiewek/devise_ldap_authenticatable.git"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'foundation-rails', '~> 5.5.0'
gem "font-awesome-rails"

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# oauth provider library
gem 'doorkeeper'

# Admin configurable settings
gem 'configurable_engine'

# Simplifies forms
gem 'simple_form'

# Redis cache interface
gem 'redis-rails'

# Pagination support
gem 'will_paginate-foundation'

# Kerberos bindings (authenticate against Chalmers kerberos)
gem 'rkerberos'

# Authorisation framework
gem 'pundit'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
end

group :production do
  gem 'therubyracer',  platforms: :ruby
end

gem 'rspec-rails', group: [:development, :test]
group :test do
  gem 'guard-rspec'
end

gem 'devise'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
# Gem for obfuscating profile images name
gem 'digest'

# Gem for uploading images
gem 'carrierwave'
# Gem for converting images
gem 'mini_magick'

# Gem for materialize
gem 'materialize-sass'
