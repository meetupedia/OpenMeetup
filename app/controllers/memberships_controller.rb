# encoding: UTF-8

class MembershipsController < CommonController
  load_resource :group
  load_resource :membership, through: :group, shallow: true
  authorize_resource except: [:set]
  before_filter :set_add_membership_for, only: [:set]
  before_filter :authenticate, only: [:set]

  def index
    redirect_to @group
  end

  def show
    redirect_to @group
  end


  def create
    unless @group.membership_for(current_user)
      @membership.save
      cookies.delete :add_membership_for
    end
    flash[:code] = "modalbox.create('#{tags_group_url(@group)}')" if @group.tags.size > 0
    redirect_to @group
  end

  def destroy
    unless @membership.is_admin? and @membership.group.admins.count > 1
      @membership.destroy
      if request.xhr?
        render :create
      else
        redirect_to @membership.group
      end
    else
      redirect_to @membership.group, alert: 'Nem törölheted magad, ha nincsen legalább két admin!'
    end
  end

  def set
    @membership = @group.memberships.build
    create
  end

  def set_admin
    @membership.is_admin = true
    @membership.save
    redirect_to members_group_url(@membership.group)
  end

  def unset_admin
    @membership.is_admin = false
    @membership.save
    redirect_to members_group_url(@membership.group)
  end

protected

  def set_add_membership_for
    cookies[:add_membership_for] = @group.id
  end
end
