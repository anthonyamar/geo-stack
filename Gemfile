# frozen_string_literal: true

source 'https://rubygems.org'

ruby '4.0.5'

# Backend
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.1'

# Jobs
gem 'mission_control-jobs'
gem 'solid_queue', '~> 1.2'

# Frontend and JavaScript
gem 'jsbundling-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails', '~> 4.2'
gem 'turbo-rails'

# Design patterns
gem 'draper'
gem 'jbuilder'
gem 'view_component'

# Users
gem 'devise'

# Email
gem 'resend'

# Utilities
gem 'bootsnap', require: false
gem 'figaro'
gem 'image_processing', '~> 1.2'
gem 'kramdown'

# Components
gem 'mapbox-sdk'
gem 'mapkick-rb'
gem 'pagy', '~> 43.0'

# Geomatic using PostgreSQL with PostGIS [https://github.com/rgeo/rgeo]
gem 'activerecord-postgis-adapter'
gem 'geocoder'
gem 'rgeo', '>= 3.1'
gem 'rgeo-activerecord'

# Search & comparison
gem 'jaro_winkler'
gem 'pg_search'

# Solution for managing countries, timezone and currencies [https://github.com/countries/countries]
gem 'countries'
gem 'money'
gem 'restcountry'
gem 'timezone'
gem 'tzinfo-data', platforms: %i[jruby]

# SEO
gem 'friendly_id'
gem 'sitemap_generator'

# Error monitoring (optional — set BUGSNAG_API_KEY)
gem 'bugsnag', '~> 6.30'

group :development, :test do
  gem 'benchmark'
  gem 'bullet'
  gem 'byebug', platforms: %i[mri]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'selenium-webdriver'
end

group :development do
  gem 'annotaterb'
  # gem 'better_errors' - Waiting for a fix of BindingOfCaller gem to work with Ruby 4
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'letter_opener_web', '~> 3.0'
  gem 'meta_request'
  gem 'rails_devtools'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'minitest-reporters'
  gem 'minitest-stub-const'
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'shoulda'
  gem 'simplecov', require: false
end
