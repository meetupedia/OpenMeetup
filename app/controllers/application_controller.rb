# encoding: UTF-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :check_restricted_access, :set_invitation_code

  helper_method :current_city, :current_language, :current_user
  helper LaterDude::CalendarHelper

  auto_user

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception do |exception|
      handling_error 500, exception
    end

    rescue_from ActionController::RoutingError, ActionController::UnknownController, AbstractController::ActionNotFound, ActiveRecord::RecordNotFound do |exception|
      handling_error 404, exception
    end

    rescue_from CanCan::AccessDenied do |exception|
      unless current_user
        flash[:alert] = 'Be kell jelentkezned!'
        authenticate
      else
        flash[:alert] = 'Nem hozzáférhető számodra a kért oldal!'
        redirect_to root_url
      end
    end
  end

private

  def handling_error(status, exception)
    ExceptionNotifier::Notifier.exception_notification(request.env, exception, :data => {:message => 'an error happened'}).deliver
    respond_to do |format|
      format.html { render "errors/error_#{status}", :status => status }
      format.any { render :nothing => true, :status => status }
    end
  end

  if Rails.env == 'development'
    def tr(text)
      text
    end

    def trl(text)
      text
    end
  end

  def run_later
    Thread.new do
      yield
      ActiveRecord::Base.connection.close
    end
  end


  # before_filter :miniprofiler

  # def miniprofiler
  #   Rack::MiniProfiler.authorize_request if current_user.andand.is_admin?
  # end


  def current_locale
    if params[:locale]
      session[:locale] = params[:locale]
    elsif not session[:locale]
      session[:locale] = if current_user.andand.locale
        current_user.locale
      elsif Settings.default_language
        Settings.default_language
      else
        tr8n_user_preffered_locale
      end
    end
    session[:locale]
  end
  helper_method :current_locale

  def create_activity(item)
    Activity.create_from(item, current_user, @group, @event)
  end

  def current_language
    @current_language ||= Language.find_by_code(I18n.locale)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def authenticate
    unless current_user
      store_location
      redirect_to sign_in_url
    end
  end

  def check_restricted_access
    if current_user.andand.restricted_access
      redirect_to root_url
    end
  end

  def set_invitation_code
    if params[:invitation_code]
      cookies[:invitation_code] = params[:invitation_code]
    end
  end

  def redirect_back_or_default(default)
    redirect_to session[:return_to] || default
    session[:return_to] = nil
  end

  def current_city
    return @current_city if defined?(@current_city)
    @current_city = session[:city] || current_user.andand.city || City.first
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].andand.scan(/^[a-z]{2}/).andand.first
  end

  def set_city
    if not Settings.standalone and current_user and not current_city
      store_location
      redirect_to edit_city_user_path(current_user)
    end
  end

  def set_locale
    I18n.locale = current_locale
    current_user.update_attribute :locale, I18n.locale if current_user and not current_user.locale == I18n.locale.to_s
  end

  def use_invite_process?
    Settings.enable_invite_process and not (cookies[:invitation_code].present? and (EventInvitation.find_by_code(cookies[:invitation_code]) or GroupInvitation.find_by_code(cookies[:invitation_code]) or cookies[:invitation_code] == Settings.skip_invite_process_code))
  end
  helper_method :use_invite_process?

  def groups_show
    @activities = @group.activities.where('activable_type NOT IN (?)', ['Comment']).order('created_at DESC').paginate :page => params[:page]
    @title = @group.name
    @static_follow = true
    render 'groups/show'
  end

  def events_show
    @title = @event.title
    if Time.zone.now.between?(@event.start_time, @event.end_time)
      render 'events/show'
    else
      render 'events/actual'
    end
  end
end
