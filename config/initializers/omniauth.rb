# -*- encoding : utf-8 -*-

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, '107811069346219', 'fff929f20a7647fb6bd2b11e5ae12038', :scope => 'email,offline_access,publish_stream,user_birthday,user_location'
end
