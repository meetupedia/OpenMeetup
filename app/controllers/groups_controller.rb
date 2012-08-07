# encoding: UTF-8

class GroupsController < CommonController
  load_resource
  authorize_resource :except => [:index, :show, :events, :images, :members]

  def show
    @title = @group.name
    @static_follow = true
  end

  def new
  end

  def create
    if @group.save
      create_activity @group
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
    @memberships = @group.memberships.includes(:user).paginate :page => params[:page]
  end

  def waves
    @waves = @group.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end
end
