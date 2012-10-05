# encoding: UTF-8

class MembershipsController < CommonController
  load_resource :group
  load_resource :membership, :through => :group, :shallow => true
  authorize_resource :except => [:set]
  before_filter :authenticate, :only => [:set]

  def create
    unless @group.membership_for(current_user)
      @membership.save
      create_activity @membership
      run_later do
        @group.admins.each do |user|
          GroupMailer.join(@membership, user).deliver if user.email
        end
      end
    end
    redirect_to @group unless request.xhr?
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
      redirect_to @membership.group, :alert => 'Nem törölheted magad, ha nincsen legalább két admin!'
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
end
