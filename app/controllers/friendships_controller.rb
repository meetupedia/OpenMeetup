class FriendshipsController < CommonController
  load_resource :user
  load_resource :friendship, through: :user, shallow: true, except: [:create]
  authorize_resource

  def create
    @friendship = Friendship.new friend_id: @user.id
    unless current_user.friendship_for(@user)
      @friendship.save
      create_activity @friendship
    end
    redirect_to @user unless request.xhr?
  end

  def destroy
    @friendship.destroy
    if request.xhr?
      render :create
    else
      redirect_to @friendship.friend
    end
  end

  def decline
    @friendship.destroy
    redirect_to @friendship.user
  end

  def set_confirmed
    @friendship.update_attributes is_confirmed: true, is_delayed: false
    @friendship.create_inverse
    redirect_to @friendship.user
  end

  def set_delayed
    @friendship.update_attributes is_delayed: true
    redirect_to @friendship.user
  end
end
