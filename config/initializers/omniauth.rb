Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, '157238154392325', '34919077d9ba820390cab00578879966', :scope => 'email,offline_access,publish_stream,user_birthday,user_location'
end
