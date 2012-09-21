# encoding: UTF-8

class GroupInvitationsController < CommonController
  load_resource :group
  load_resource :group_invitation, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def new
  end

  def create
    unless @group_invitation.ids.blank?
      @group_invitation.ids.split(',').each do |id|
        if user = User.find_by_id(id)
          group_invitation = GroupInvitation.find_or_initialize_by_group_id_and_invited_user_id(@group.id, user.id)
          group_invitation.email ||= user.email
        else
          group_invitation = GroupInvitation.find_or_initialize_by_group_id_and_email(@group.id, id)
        end
        if group_invitation.new_record?
          group_invitation.message = @group_invitation.message
          if group_invitation.save
            run_later { GroupInvitationMailer.invitation(group_invitation).deliver }
          end
        end
      end
      redirect_to invited_group_path(@group), :notice => 'Meghívó elküldve.'
    else
      redirect_to @group
    end
  end
end
