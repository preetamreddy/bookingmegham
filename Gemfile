source 'http://rubygems.org'

gem 'rails', '3.1.10'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

# For nested forms, especially Trip and Bookings
gem "nested_form", :git => "git://github.com/ryanb/nested_form.git"

gem 'will_paginate', '~> 3.0'

# For password encryption
gem 'bcrypt-ruby'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'pg'
end

# Web server
gem 'thin'

# Converting HTMLs to PDF
gem 'wicked_pdf'

# For CSV file generation
gem 'fastercsv'
gem "comma", "~> 3.0"

# For creating test data
gem 'factory_girl_rails'

# For creating fake data
gem "faker", :git => "git://github.com/stympy/faker.git"

# For authentication
gem 'devise'

# For static pages
gem "high_voltage"

# For authorization
gem "cancan"

# For debugging
group :development do
  gem 'ruby-debug19'
end

# For client side validations
gem 'client_side_validations'

# For tooltips
gem 'simple-tooltip'

# For autocomplete
gem 'rails3-jquery-autocomplete'

# For recaptcha
gem "recaptcha", :require => "recaptcha/rails"
