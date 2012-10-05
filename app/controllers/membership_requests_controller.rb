# encoding: UTF-8

class MembershipRequestsController < CommonController
  load_resource :group
  load_resource :membership_request, :through => :group, :shallow => true

  def create
    if not @group.membership_for(current_user) and not @group.membership_request_for(current_user)
      @membership_request.save
      run_later do
        @group.admins.each do |user|
          MembershipRequestMailer.created(@membership_request, user).deliver
        end
      end
    end
    redirect_to @group
  end

  def destroy
    @membership_request.destroy
    redirect_to requested_members_group_url(@membership_request.group)
  end

  def confirm
    @membership_request.group.memberships.create(:user_id => @membership_request.user_id)
    run_later { MembershipRequestMailer.confirmed(@membership_request).deliver }
    @membership_request.destroy
    redirect_to requested_members_group_url(@membership_request.group)
  end
end
