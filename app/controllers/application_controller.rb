# -*- encoding : utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :set_city, :set_domain
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

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  helper_method :current_user

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].andand.scan(/^[a-z]{2}/).andand.first
  end

  def set_city
    cookies[:city] = params[:city] || current_user.andand.city || 'Budapest'
  end

  def set_domain
#    host = request.env['HTTP_HOST'].split(':').first
#    request.env['rack.session.options'][:domain] = ".#{host}"
  end

  def set_layout
    current_organization.andand.layout_name || 'application'
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end
end
