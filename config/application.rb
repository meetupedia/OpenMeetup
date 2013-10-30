require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(assets: %w(development test)))
end

module Openmeetup
  class Application < Rails::Application
    config.time_zone = 'Budapest'
    config.i18n.default_locale = :en
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'

    GC::Profiler.enable
  end
end
