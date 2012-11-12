class CitiesController < CommonController
  load_resource
  authorize_resource :except => [:index, :show, :city_names, :search]

  def index
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").includes(:country)
    respond_to do |format|
      format.json { render :json => @cities.map { |city| {:id => city.id, :name => tr(city.display_name)} } }
    end
  end

  def show
  end

  def city_names
    @cities = City.where('name LIKE ?', "%#{params[:q]}%").includes(:country)
    respond_to do |format|
      format.json { render :json => @cities.map { |city| tr(city.display_name) } }
    end
  end

  def search
    city_name, country_name = $1, $3 if params[:city][:name] =~ /([^(]+)( *\(([^)]+)\))*/
    @cities = City.where(:name => city_name)
    if country = Country.find_by_name(country_name)
      @cities = @cities.where(:country_id => country.id)
    end
    if @city = @cities.first
      redirect_to @city
    else
      redirect_to root_url
    end
  end
end
