# -*- encoding : utf-8 -*-

class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show, :activities, :groups, :request_invite, :validate_email]
  before_filter :set_city, :except => [:edit, :update, :edit_city]
  before_filter :create_city, :only => [:new, :request_invite, :edit_city]
  skip_before_filter :check_restricted_access, :only => [:create, :request_invite]

  def index
    @users = User.where('name LIKE ?', "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @users.map { |user| {:id => user.id, :name => user.name} } }
    end
  end

  def show
  end

  def new
  end

  def create
    if Settings.enable_invite_process
      @user.invitation_code = SecureRandom.hex(16)
      @user.restricted_access = true
    end
    if @user.save
      redirect_to interests_url
    else
      render :new
    end
  end

  def update
    @user.update_attributes params[:user]
    redirect_back_or_default @user
  end

  def activities
  end

  def dashboard
  end

  def edit_city
  end

  def groups
    @groups = @user.joined_groups.paginate :page => params[:page]
    @admined_groups = @user.admined_groups
  end

  def facebook_groups
    @facebook_groups = @user.facebook.groups
  end

  def request_invite
  end

  def settings
  end

  def tags
  end

  def validate_email
    render :json => !User.find_by_email(params[:user][:email])
  end

  def waves
    @waves = current_user.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end

protected

  def create_city
    country = Country.find_or_create_by_name_and_code(request.location.country, request.location.country_code)
    @city = City.find_or_initialize_by_name_and_country_id(request.location.city, country.id)
    if @city.new_record?
      @city.state = request.location.state
      @city.save
    end
  end
end
