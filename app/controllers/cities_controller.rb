class CitiesController < CommonController
  load_resource
  authorize_resource :except => [:index, :show]

  def index
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").includes(:country)
    respond_to do |format|
      format.json { render :json => @cities.map { |city| {:id => city.id, :name => tr(city.display_name)} } }
    end
  end

  def show
  end
end
