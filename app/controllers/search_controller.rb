# -*- encoding : utf-8 -*-

class SearchController < ApplicationController

  def index
    @groups = Group.where('name LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order('name ASC').limit(10)
    @events = Event.where('title LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order('start_time DESC').limit(10)
  end
end
