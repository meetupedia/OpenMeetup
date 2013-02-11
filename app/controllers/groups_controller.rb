# encoding: UTF-8

class GroupsController < CommonController
  load_resource
  authorize_resource :except => [:index, :show, :events, :images, :members]

  def show
    @membership_requests = @group.membership_requests.order('created_at ASC').includes(:user).paginate :page => params[:page]
    groups_show
  end

  def new
  end

  def create
    if @group.save
      create_activity @group
      GroupMailer.creation_for_owner(@group).deliver
      User.where(:is_admin => true).each do |user|
        GroupMailer.creation(@group, user).deliver if user.email
      end
      redirect_to @group
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update_attributes params[:group]
      redirect_to @group
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_user_path(current_user)
  end

  def events
    @events = @group.events.order('start_time DESC').paginate :page => params[:page]
  end

  def images
  end

  def invited
    @group_invitations = @group.group_invitations.order('created_at DESC').page(params[:page])
  end

  def members
    @memberships = @group.memberships.order('is_admin DESC, created_at ASC').includes(:user).paginate :page => params[:page]
  end

  def requested_members
    @membership_requests = @group.membership_requests.order('created_at ASC').includes(:user).paginate :page => params[:page]
  end

  def set_image
    if image = Image.find_by_id(params[:image_id])
      @group.image = File.open(image.image.path)
      @group.save
    end
    redirect_to @group
  end

  def set_header
    if image = Image.find_by_id(params[:image_id])
      @group.header = File.open(image.image.path)
      @group.save
    end
    redirect_to @group
  end

  def waves
    @waves = @group.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end

end
