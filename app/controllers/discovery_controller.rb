# encoding: UTF-8

class DiscoveryController < CommonController
  before_filter :authenticate
  before_filter :set_city, only: [:index, :events]

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
    @events = Event.paginate page: params[:page]
    @events = @events.joins(group: :city).where('groups.city_id' => @city.id) unless Settings.standalone
  end

  def friends
  end

  def interests
  end

  def newsfeed
  end

private

  def set_city
    unless Settings.standalone
      session[:city_id] ||= current_user.city_id
      session[:city_id] = params[:city][:id] if params[:city].andand[:id]
      @city = City.where(id: session[:city_id]).first
    end
  end
end
