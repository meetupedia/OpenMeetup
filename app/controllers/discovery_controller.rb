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
