require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'

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

    # bootstrap form fix
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| "<span class='has-error'>#{html_tag}</span>".html_safe }

    GC::Profiler.enable
  end
end
