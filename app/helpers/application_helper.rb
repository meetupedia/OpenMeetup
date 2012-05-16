# -*- encoding : utf-8 -*-

module ApplicationHelper

  def user_avatar(user)
    filename = case user.provider
      when 'facebook' then "https://graph.facebook.com/#{user.uid}/picture"
      else 'default_avatar.png'
    end
    link_to(image_tag(filename, :alt => user.name, :height => 32, :width => 32, :title => user.name, :class => 'avatar_image'), user)
  end

  def user_link(user)
    link_to user.name, user
  end

  def sign_in_path
    provider = Rails.env == 'development' ? 'developer' : 'facebook'
    case provider
#      when 'facebook' then "http://openmeetup.net/sign_in/facebook?return_to=http://#{request.domain}"
      when 'facebook', then '/auth/facebook'
      when 'developer' then '/auth/developer'
    end
  end

  def calendar(start_time, end_time)
    calendar_for(start_time.year, start_time.month, :current_month => '%Y. %B') do |date|
      style = (start_time.beginning_of_day <= date and end_time.end_of_day >= date) ? 'on_day' : ''
      content_tag :span, date.day, :class => style
    end
  end

  def dot
    ' · '
  end
end
