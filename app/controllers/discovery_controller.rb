# encoding: UTF-8

class DiscoveryController < CommonController
  before_filter :authenticate
  before_filter :set_city

  def index
    unless params[:q].blank?
      @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      order = case params[:order]
        when 'name' then 'name ASC'
        when 'members' then 'memberships_count DESC'
        else 'id ASC'
      end
      @groups = Group.order(order).paginate :page => params[:page]
    end
  end

  def search
    index
  end
end
