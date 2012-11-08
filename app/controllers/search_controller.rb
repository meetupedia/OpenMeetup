# encoding: UTF-8

class SearchController < CommonController

  def index
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").order('name ASC').limit(10)
    @groups = Group.where('name LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order('name ASC').limit(10)
    @events = Event.where('title LIKE ? OR description LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%").order('start_time DESC').limit(10)
  end
end
