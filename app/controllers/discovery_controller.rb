# encoding: UTF-8

class DiscoveryController < CommonController
  before_filter :authenticate
  before_filter :use_city, only: [:index, :events, :interests]

  def index
    unless params[:q].blank?
      @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      order = case params[:order]
        when 'name' then 'name ASC'
        when 'members' then 'memberships_count DESC'
        else 'id ASC'
      end
      @groups = Group.order(order).paginate page: params[:page]
      if Settings.group_discovery_min_member_count and Settings.group_discovery_mandatory_header_image
        @groups = @groups.where('memberships_count >= ?', Settings.group_discovery_min_member_count).where('image_updated_at IS NOT ?', nil)
      elsif Settings.group_discovery_min_member_count
        @groups = @groups.where('memberships_count >= ?', Settings.group_discovery_min_member_count)
      elsif Settings.group_discovery_mandatory_header_image
        @groups = @groups.where('image_updated_at IS NOT ?', nil)
      end
      @groups = @groups.joins(:city).where('groups.city_id' => @city.id) unless Settings.standalone
    end
  end

  def events
    @events = Event.where('start_time > ?', Time.now).order('start_time ASC').paginate page: params[:page]
    @events = @events.joins(group: :city).where('groups.city_id' => @city.id) unless Settings.standalone
  end

  def friends
    @users = User.where(id: current_user.friend_ids).order('name ASC').paginate page: params[:page]
  end

  def interests
    @tags = Tag.order('name ASC').paginate page: params[:page]
    @tags = @tags.joins(groups: :city).where('groups.city_id' => @city.id) unless Settings.standalone
  end

  def newsfeed
    @activities = Activity.where(user_id: current_user.friend_ids).order('created_at DESC').paginate page: params[:page]
  end
end
