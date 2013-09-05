# encoding: UTF-8

class TagsController < CommonController
  load_resource :group
  load_resource :tag, through: :group, shallow: true, except: [:create]
  authorize_resource except: [:index, :show]
  before_filter :use_city, only: [:show]

  def index
    respond_to do |format|
      format.html do
        @tags = Tag.order('name ASC')
      end
      format.json do
        @tags = Tag.where('name LIKE ?', "%#{params[:q]}%")
        render json: @tags.map { |tag| {id: tag.id, name: tag.name} }
      end
    end
  end

  def show
    @groups = @tag.groups
    @groups = @groups.joins(:city).where('groups.city_id' => @city.id) unless Settings.standalone
    @users = @tag.users
    @users = @users.joins(:city).where('users.city_id' => @city.id) unless Settings.standalone
  end

  def new
  end

  def create
    if @tag = Tag.find_or_create_by_name(params[:tag][:name])
      if @group
        @group.tags << @tag
        redirect_to @group
      else
        redirect_to @tag
      end
    else
      render :new
    end
  end
end
