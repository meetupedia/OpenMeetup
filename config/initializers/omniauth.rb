# encoding: UTF-8

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, 'XtizKOl8AY2yQ0Pd7szjA', 'b7FfTYtvWjBN0od5PHaHf5PrpxWgJinuc6bcm1m70'
  provider :facebook, '107811069346219', 'fff929f20a7647fb6bd2b11e5ae12038', :scope => 'email,offline_access,publish_stream,user_birthday,user_location,user_groups', :iframe => true
end
