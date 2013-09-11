# encoding: UTF-8

module MailUrlizer

  def self.included(base)
    base.class_eval do
      alias_method_chain :collect_responses_and_parts_order, :reformat
    end
  end

  def collect_responses_and_parts_order_with_reformat(headers, &block)
    responses, order = collect_responses_and_parts_order_without_reformat(headers, &block)
    [responses.map { |response| reformat(response) }, order]
  end

  def reformat(response)
    if response[:content_type] == 'text/html'
      response.merge body: response[:body].gsub('href="/', %{href="http://#{Settings.host}/})
    else
      response
    end
  end
end


class CommonMailer < ActionMailer::Base
  include MailUrlizer
  prepend_view_path Rails.root + 'app' + 'mailer_views'
  helper :common
  helper :application
  layout Settings.mailer_template || 'mailer'
  default_url_options[:host] = Settings.host
  default from: Settings.default_email

  def perform_caching
    false
  end

  def set_locale(locale)
    I18n.locale = locale
    Thread.current[:tr8n_current_language] = Tr8n::Language.for(I18n.locale)
  end
end
