Openmeetup::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = true
  config.assets.digest = true
  config.action_dispatch.x_sendfile_header = 'X-Sendfile'
  config.log_tags = [lambda { |r| DateTime.now }]
  config.cache_store = :dalli_store
  config.threadsafe!
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  Airbrake.configure do |config|
    config.api_key = Settings.errbit.api_key
    config.host = Settings.errbit.host
    config.port = Settings.errbit.port
    config.secure = config.port == 443
  end

  config.action_mailer.smtp_settings = {
    address: 'localhost',
    port: 25,
    domain: 'meetupedia.com',
    user_name: nil,
    password: nil,
    authentication: nil,
    enable_starttls_auto: false
  }.merge(Settings.smtp || {})

  # Handling error messages dynamically
  config.exceptions_app = self.routes
end
