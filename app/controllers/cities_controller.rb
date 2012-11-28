class CitiesController < CommonController
  load_resource
  authorize_resource :except => [:index, :show, :jump, :search]

  def index
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").includes(:country)
    respond_to do |format|
      format.json { render :json => @cities.map { |city| {:id => city.id, :name => tr(city.display_name)} } }
    end
  end

  def show
    unless params[:q].blank?
      @groups = @city.groups.joins(:tags).where('groups.name LIKE ? OR tags.name LIKE ?', "%#{params[:q]}%", "#{params[:q]}%").group('groups.id')
    else
      order = case params[:order]
        when 'name' then 'name ASC'
        when 'members' then 'memberships_count DESC'
        else 'id ASC'
      end
      @groups = @city.groups.order(order).paginate :page => params[:page]
    end
  end

  def jump
    if @city = City.find_by_id(params[:city][:id])
      redirect_to @city
    else
      redirect_to root_url
    end
  end

  def search
    show
  end
end
