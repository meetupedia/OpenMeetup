# encoding: UTF-8

module ApplicationHelper

  def user_avatar(user)
    link_to user_avatar_img(user), user
  end

  def user_avatar_img(user)
    filename = user.avatar(:small) if user.avatar.file?
    filename ||= "https://graph.facebook.com/#{user.facebook_id}/picture" if user.facebook_id
    filename ||= 'default_avatar.png'
    image_tag(filename, alt: user.name, height: 32, width: 32, title: user.name, class: 'avatar_image')
  end

  def user_link(user)
    link_to user.name.presence || trl("Citizen #{user.id}"), user
  end

  def auth_path(provider)
    provider = :developer if Rails.env.development?
    case provider
      when :facebook then '/auth/facebook'
      when :twitter then '/auth/twitter'
      when :developer then '/auth/developer'
    end
  end

  def calendar(start_time, end_time)
    calendar_for(start_time.year, start_time.month, current_month: '%Y. %B') do |date|
      style = (start_time.beginning_of_day <= date and end_time.end_of_day >= date) ? 'on_day' : ''
      content_tag :span, date.day, class: style
    end
  end

  def dot
    ' · '
  end


  def button_to(name, options = {}, html_options = {})
    html_options = html_options.stringify_keys
    convert_boolean_attributes!(html_options, %w( disabled ))

    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', type: 'hidden', name: '_method', value: method.to_s)
    end

    form_method = method.to_s == 'get' ? 'get' : 'post'
    form_options = html_options.delete('form') || {}
    form_options[:class] ||= html_options.delete('form_class') || 'button_to'

    remote = html_options.delete('remote')

    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, type: "hidden", name: request_forgery_protection_token.to_s, value: form_authenticity_token)
    end

    url = options.is_a?(String) ? options : self.url_for(options)
    name ||= url

    html_options = convert_options_to_data_attributes(options, html_options)

    html_options.merge!("type" => "submit")

    form_options.merge!(method: form_method, action: url)
    form_options.merge!("data-remote" => "true") if remote

    "#{tag(:form, form_options, true)}<div>#{method_tag}#{content_tag("button", name, html_options)}#{request_token_tag}</div></form>".html_safe
  end
end
