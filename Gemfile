source 'https://rubygems.org'

gem 'rails', '3.2.11'

platform :ruby do
  gem 'mysql2'
end

platform :jruby do
  gem 'activerecord-jdbc-adapter'
  gem 'jdbc-mysql', :require => false
  gem 'activerecord-jdbcmysql-adapter'
end

gem 'json'
gem 'jquery-rails', '2.1.1'
gem 'rails-i18n'
gem 'rails_config'
gem 'andand'
gem 'mini_record'
gem 'slim'
gem 'cancan'
gem 'bootstrap-sass'
gem 'formtastic'
gem 'formtastic-bootstrap'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'fb_graph'
gem 'geocoder'
# gem 'gmaps4rails'
gem 'railhead_autouser'
gem 'railhead_permalink'
gem 'paperclip', '~> 2.7'
gem 'mime-types', :require => 'mime/types'
gem 'paper_trail'
gem 'globalize3'
gem 'later_dude'
gem 'rails_autolink'
gem 'authlogic'
gem 'fancybox-rails'
# gem 'turbolinks'
gem 'kaminari'
gem 'will_filter'
gem 'roadie'
gem 'mail_view'
gem 'exception_notification'
gem 'RedCloth'
# gem 'oink'
gem 'tr8n', :git => 'https://github.com/berk/tr8n.git', :ref => '973fb5277bfe25270687fba9e519b7ff1e41fd5d'
gem 'dalli'
gem 'sitemap_generator'
gem 'whenever', :require => false
gem 'jquery-fileupload-rails'
# gem 'cache_digests'
gem 'rails-timeago'
gem 'spork-rails'
gem 'spork-testunit'
gem 'gabba'

gem 'sass-rails', '~> 3.2.3'
gem 'coffee-rails', '~> 3.2.1'

group :assets do
  gem 'therubyrhino', :platform => :jruby
  gem 'therubyracer', :platform => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'hirb'
  gem 'license_finder', :git => 'https://github.com/pivotal/LicenseFinder.git'
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
