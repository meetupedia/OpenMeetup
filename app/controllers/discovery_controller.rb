# encoding: UTF-8

class DiscoveryController < CommonController
  before_filter :authenticate

  def index
    unless params[:q].blank?
      @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      order = case params[:order]
        when 'name' then 'name ASC'
        when 'members' then 'memberships_count DESC'
        else 'id ASC'
      end
      @groups = Group.order(order)
      if Settings.group_discovery_min_member_count and Settings.group_discovery_mandatory_header_image
        @groups = @groups.where('memberships_count >= ?', Settings.group_discovery_min_member_count).where('image_updated_at IS NOT ?', nil)
      elsif Settings.group_discovery_min_member_count
        @groups = @groups.where('memberships_count >= ?', Settings.group_discovery_min_member_count)
      elsif Settings.group_discovery_mandatory_header_image
        @groups = @groups.where('image_updated_at IS NOT ?', nil)
      end
      unless Settings.standalone
        @city = params[:group].andand[:city_id] ? City.find_by_id(params[:group][:city_id]) : current_user.city
        @groups = @groups.joins(:city).where('groups.city_id' => @city.id)
      end
      @groups = @groups.paginate page: params[:page]
    end
  end

  def events
  end

  def friends
  end

  def groups
  end

  def interests
  end

  def newsfeed
  end
end
