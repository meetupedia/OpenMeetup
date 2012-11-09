class CitiesController < CommonController
  load_resource
  authorize_resource :except => [:index, :show, :search]

  def index
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").includes(:country)
    respond_to do |format|
      format.json { render :json => @cities.map { |city| {:id => city.id, :name => tr(city.display_name)} } }
    end
  end

  def show
  end

  def search
    @city = City.find_by_id(params[:city][:id])
    redirect_to @city
  end
end
