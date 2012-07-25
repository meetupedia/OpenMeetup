# encoding: UTF-8

class DiscoveryController < ApplicationController
  before_filter :authenticate
  before_filter :set_city

  def index
    unless params[:q].blank?
      @groups = Group.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      @groups = Group.paginate :page => params[:page]
    end
  end

  def search
    index
    render :layout => false
  end
end
