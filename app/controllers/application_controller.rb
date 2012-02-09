class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  helper_method :current_user

  auto_user

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  def create_activity(item)
    Activity.create :activable_type => item.class.name, :activable_id => item.id
  end
end
