# encoding: UTF-8

class RootController < CommonController
  before_filter :unauthenticate, only: [:sign_in]
  skip_before_filter :check_restricted_access, only: [:index, :restricted_access]

  def index
    if current_user
      if current_user.restricted_access
        redirect_to restricted_access_url
      else
        # @user = current_user
        # render 'users/calendar'
        redirect_to discovery_url
      end
    elsif Settings.customization
      template = "customizations/#{Settings.customization}"
      render template if File.file?(File.join(Rails.root, 'app/views', template + '.html.slim'))
    end
  end

  def intro
    render :index
  end

  def about
  end

  def developer_dashboard
  end

  def dashboard
    unless current_user.andand.is_admin?
      redirect_to root_url
    end
    @activities = Activity.order('created_at DESC').paginate page: params[:page]
  end

  def restricted_access
  end

  def sign_in
    if current_user
      redirect_to root_url
    else
      session[:return_to] = params[:return_to] if params[:return_to]
      redirect_to sign_in_with_email_path unless Settings.enable_facebook_login or Settings.enable_twitter_login
    end
  end

  def undefined
    if @group = Group.find_by_permaname(params[:id])
      groups_show
    elsif @event = Event.find_by_permaname(params[:id])
      events_show
    else
      render 'errors/error_404.html', status: 404
    end
  end
end
