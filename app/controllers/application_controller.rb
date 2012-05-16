# -*- encoding : utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :set_city
  helper_method :current_language, :current_organization, :current_user
  helper LaterDude::CalendarHelper
  layout :set_layout

  auto_user

  if Rails.env == 'production'
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => 'Nincsen megfelelő jogosultságod ehhez!'
    end
  end

private

  def create_activity(item)
    Activity.create :activable_type => item.class.name, :activable_id => item.id
  end

  def current_language
    @current_language ||= Language.find_by_code(I18n.locale)
  end

  def current_organization
    @current_organization ||= if Rails.env == 'development'
      Organization.first
    else
      if request.domain == 'openmeetup.net'
        Organization.find_by_permalink(request.subdomains.first)
      else
        Organization.find_by_permalink(request.domain.split('.').first)
      end
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].andand.scan(/^[a-z]{2}/).andand.first
  end

  def set_city
    cookies[:city] = params[:city] || current_user.andand.city || 'Budapest'
  end

  def set_layout
    current_organization.andand.layout_name || 'application'
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end
end
