# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.4.1'

# Mandatory gems
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.1'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Assets
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'terser'

# Hotwire ecosystem
gem 'stimulus-rails'
gem 'turbo-rails'

# Front end
gem 'draper'
gem 'tailwindcss-rails', '~> 4.2'
gem 'view_component'

# Geo services
gem 'activerecord-postgis-adapter'
gem 'geocoder'
gem 'mapbox-sdk'
gem 'mapkick-rb'
gem 'rgeo'
gem 'rgeo-activerecord'

# Search
gem 'jaro_winkler'
gem 'pg_search'

# Countries
gem 'countries'
gem 'money'
gem 'restcountry'
gem 'timezone'

# SEO
gem 'friendly_id'
gem 'sitemap_generator'

# Other
gem 'devise'
gem 'figaro', git: "https://github.com/laserlemon/figaro"
gem 'jbuilder'
gem 'pagy'
gem 'redis', '>= 4.0.1'

group :development, :test do
  gem 'benchmark'
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'selenium-webdriver'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :development do
  gem 'annotaterb'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'i18n-debug'
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
