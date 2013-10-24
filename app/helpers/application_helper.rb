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


module ActionView

  module Helpers

    module FormHelper

      def easy_form_for(object, options = {})
        options[:html] ||= {}
        options[:html][:role] = 'form'
        form_for object, options do |form|
          yield form
        end
      end
    end


    class FormBuilder

      def add_required_option(name, text, options)
        options[:required] = 'required' if object.class.respond_to?(:validators) and object.class.validators_on(name).map { |validator| validator.class }.include?(ActiveModel::Validations::PresenceValidator)
        text << ' <abbr title="Kötelező megadni!">*</abbr>'.html_safe if text and options[:required]
      end

      def action(name = trl('Send'), options = {})
        easy_submit name, options.merge(class: 'btn btn-default btn-primary')
      end

      def input(*args)
        options = args.extract_options!
        name, text = args
        if not type = options.delete(:as) and object.class.respond_to?(:columns_hash)
          type = object.class.columns_hash[name.to_s].andand.type
          type ||= :file if object.class.columns_hash["#{name}_file_name"]
        end
        case type
          when :boolean then easy_check_box name, text, options
          when :date then easy_date_select name, text, options.merge(class: 'form-control')
          when :datetime then easy_datetime_select name, text, options.merge(class: 'form-control')
          when :text then easy_text_area name, text, options.merge(class: 'form-control')
          when :file then easy_file_field name, text, options
          when :email then easy_email_field name, text, options.merge(class: 'form-control')
          when :password then easy_password_field name, text, options.merge(class: 'form-control')
          else easy_text_field name, text, options.merge(class: 'form-control')
        end
      end

      def dropdown(name, text, values, options = {})
        easy_select name, text, values, options
      end

      def handle_prepend_and_append(options, &block)
        prepend = options.delete(:prepend)
        append = options.delete(:append)
        if prepend or append
          output = "<div class='input-group'>"
          output << "<span class='input-group-addon'>#{prepend}</span>" if prepend
          output << yield
          output << "<span class='input-group-addon'>#{append}</span>" if append
          output << "</div>"
          output.html_safe
        else
          yield
        end
      end

      def easy_text_field(name, text = nil, options = {})
        options.reverse_merge! maxlength: 255
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{handle_prepend_and_append(options) { text_field(name, options) } }</div>".html_safe
      end

      def easy_file_field(name, text = nil, options = {})
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{file_field(name, options)}</div>".html_safe
      end

      def easy_email_field(name, text = nil, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{handle_prepend_and_append(options) { email_field(name, options) } }</div>".html_safe
      end

      def easy_password_field(name, text = nil, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{password_field(name, options)}</div>".html_safe
      end

      def easy_text_area(name, text = nil, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{text_area(name, options)}</div>".html_safe
      end

      def easy_check_box(name, text, options = {})
        add_required_option(name, text, options)
        "<div class='checkbox'>#{label(name, check_box(name, options) + ' ' + text)}</div>".html_safe
      end

      def easy_select(name, text, values, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe)}#{select(name, values, options)}</div>".html_safe
      end

      def easy_date_select(name, text = nil, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe) + '<br />'.html_safe}#{date_select(name, options)}</div>".html_safe
      end

      def easy_datetime_select(name, text = nil, options = {})
        add_required_option(name, text, options)
        "<div class='form-group'>#{text and label(name, text.html_safe) + '<br />'.html_safe}#{datetime_select(name, options)}</div>".html_safe
      end

      def easy_submit(name = 'Mentés', options = {})
        "<div class='form-group'>#{submit(name, options)}</div>".html_safe
      end
    end
  end
end
