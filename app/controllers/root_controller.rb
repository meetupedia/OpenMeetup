# encoding: UTF-8

class RootController < CommonController
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

  def discovery
    unless params[:q].blank?
      @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      order = case params[:order]
        when 'name' then 'name ASC'
        when 'members' then 'memberships_count DESC'
        else 'id ASC'
      end
      if Settings.group_discovery_min_member_count and Settings.group_discovery_mandatory_header_image
        @groups = Group.where('memberships_count >= ?', Settings.group_discovery_min_member_count).where('image_updated_at IS NOT ?', nil).order(order).paginate page: params[:page]
      elsif Settings.group_discovery_min_member_count
        @groups = Group.where('memberships_count >= ?', Settings.group_discovery_min_member_count).order(order).paginate page: params[:page]
      elsif Settings.group_discovery_mandatory_header_image
        @groups = Group.where('image_updated_at IS NOT ?', nil).order(order).paginate page: params[:page]
      else
        @groups = Group.order(order).paginate page: params[:page]
      end
        
    end
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
