source 'https://rubygems.org'

gem 'rails', '3.2.13'

platform :ruby do
  gem 'mysql2'
end

platform :jruby do
  gem 'activerecord-jdbc-adapter'
  gem 'jdbc-mysql', require: false
  gem 'activerecord-jdbcmysql-adapter'
end

gem 'thin'
gem 'json'
gem 'jquery-rails'
gem 'rails-i18n'
gem 'rails_config'
gem 'andand'
gem 'mini_record'
gem 'tilt'
gem 'slim'
gem 'cancan', '1.6.9'
gem 'bootstrap-sass'
gem 'formtastic'
gem 'formtastic-bootstrap'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'fb_graph'
gem 'geocoder'
gem 'railhead_autouser'
gem 'railhead_permalink'
gem 'paperclip'
gem 'mime-types', require: 'mime/types'
gem 'paper_trail'
gem 'globalize3'
gem 'later_dude'
gem 'rails_autolink'
gem 'authlogic'
gem 'fancybox-rails'
gem 'kaminari'
gem 'will_filter'
gem 'roadie'
gem 'mail_view'
gem 'RedCloth'
gem 'tr8n'
gem 'dalli'
gem 'sitemap_generator'
gem 'whenever', require: false
gem 'jquery-fileupload-rails'
gem 'rails-timeago'
gem 'spork-rails'
gem 'spork-testunit'
gem 'airbrake'
# gem 'gmaps4rails'

gem 'fast_xs'
gem 'fast_blank'

gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'sass-rails'
gem 'coffee-rails'

group :assets do
  gem 'therubyrhino', platform: :jruby
  gem 'therubyracer', platform: :ruby
  gem 'uglifier'
  gem 'turbo-sprockets-rails3'
end

group :development do
  gem 'hirb'
  # gem 'license_finder', require: false, git: 'https://github.com/pivotal/LicenseFinder.git'
  gem 'bullet'
  gem 'meta_request'
  gem 'quiet_assets'
  platform :ruby do
    gem 'better_errors'
    gem 'binding_of_caller'
  end
end

group :production do
  gem 'newrelic_rpm'
end
