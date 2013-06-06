# encoding: UTF-8

class UsersController < CommonController
  load_resource except: [:create]
  authorize_resource except: [:index, :show, :groups, :request_invite, :validate_email]
  before_filter :set_city, except: [:edit, :update, :edit_city]
  before_filter :create_city, only: [:new, :request_invite, :edit_city]
  skip_before_filter :check_restricted_access, only: [:new, :create, :request_invite]

  cache_sweeper :membership_sweeper, only: [:create]
  cache_sweeper :participation_sweeper, only: [:create]

  def index
    if Settings.standalone
      @users = User.where('name LIKE ? OR email LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
      respond_to do |format|
        format.json { render json: @users.map { |user| {id: user.id, name: "#{user.name} <#{user.email}>" } } }
      end
    else
      @users = User.where('name LIKE ?', "%#{params[:q]}%")
      respond_to do |format|
        format.json { render json: @users.map { |user| {id: user.id, name: user.name } } }
      end
    end
  end

  def show
    @activities = @user.activities.order('created_at DESC').includes(:activable).paginate page: params[:page]
    @title = @user.name
  end

  def new
  end

  def create
    city = City.find_or_create_with_country(params[:user].delete(:city_id))
    @user = User.new params[:user]
    @user.city = city
    if use_invite_process?
      @user.invitation_code = SecureRandom.hex(16)
      @user.restricted_access = true
    end
    if @user.save
      create_activity @user, @user
      cookies.delete :invitation_code
      if cookies[:add_membership_for] and group = Group.find_by_id(session[:cookies_membership_for])
        group.memberships.create user: @user
        cookies.delete :add_membership_for
      end
      if cookies[:add_participation_for] and event = Event.find_by_id(cookies[:add_participation_for])
        event.participations.create user: @user
        cookies.delete :add_participation_for
      end
      redirect_to interests_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes params[:user]
      redirect_to @user
    else
      render :settings
    end
  end

  def destroy
    current_user_session.andand.destroy if @user == current_user
    @user.destroy
    redirect_to root_url, notice: trfn('User deleted.')
  end

  def calendar
  end

  def dashboard
  end

  def edit_city
  end

  def groups
    @groups = @user.joined_groups.paginate page: params[:page]
    @admined_groups = @user.admined_groups
  end

  def facebook_groups
    @facebook_groups = @user.facebook.groups
  end

  def request_invite
    redirect_to sign_in_path unless Settings.enable_invite_process
  end

  def set_admin
    # unless request.method == 'GET'
      @user.is_admin = true
      @user.save validate: false
      begin
        UserMailer.set_admin(@user).deliver
      rescue
      end
      redirect_to @user, notice: trfn('User is now admin.')
    # else
    #   redirect_to @user, alert: trfe('Wrong query!')
    # end
  end

  def unset_admin
    # unless request.method == 'GET'
      @user.is_admin = false
      @user.save validate: false
      redirect_to @user, notice: trfn('User is not an admin anymore.')
    # else
    #   redirect_to @user, alert: trfe('Wrong query!')
    # end
  end

  def settings
  end

  def tags
  end

  def validate_email
    render json: !User.find_by_email(params[:user][:email])
  end

  def waves
    @waves = current_user.waves.order('last_changed_at DESC').paginate page: params[:page]
  end

  def newsletter_insights_for_group_admin
    @admined_groups = @user.admined_groups
    begin
      UserMailer.newsletter_insights_for_group_admin(@user).deliver
    rescue
    end
  end

  def recommendations
    user_ids = current_user.recommended_users_hash.to_a.map(&:first)
    @users = User.find(user_ids)
    group_ids = current_user.recommended_groups_hash.to_a.map(&:first)
    @groups = Group.find(group_ids)
  end

  def set_avatar
    if image = Image.find_by_id(params[:image_id])
      @user.avatar = File.open(image.image.path)
      @user.save
    end
    redirect_to @user, notice: trfn('User profile image updated.')
  end

  def set_header
    if image = Image.find_by_id(params[:image_id])
      @user.header = File.open(image.image.path)
      @user.save
    end
    redirect_to @user, notice: trfn('User header image updated.')
  end

protected

  def create_city
    if request.location
      country = Country.find_or_create_by_name_and_code(request.location.country, request.location.country_code)
      city = City.find_or_initialize_by_name_and_country_id(request.location.city, country.id)
      if city.new_record?
        city.state = request.location.state
        city.save
      end
    end
  end
end
