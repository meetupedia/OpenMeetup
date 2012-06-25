class DiscoveryController < ApplicationController

  def index
    @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%") if params[:q]
    Rails.logger.info @groups.inspect
  end

  def search
    index
    render :layout => false
  end
end
