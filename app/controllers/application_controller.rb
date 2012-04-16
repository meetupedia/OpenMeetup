# -*- encoding : utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  helper_method :current_user
  helper LaterDude::CalendarHelper

  auto_user

  if Rails.env == 'production'
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => 'Nincsen megfelelő jogosultságod ehhez!'
    end
  end

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def create_activity(item)
    Activity.create :activable_type => item.class.name, :activable_id => item.id
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
  end
end
