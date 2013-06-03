# encoding: UTF-8

class GroupInvitationsController < CommonController
  load_resource :group
  load_resource :group_invitation, through: :group, shallow: true
  authorize_resource except: [:index, :show, :users]

  def new
  end

  def create
    unless @group_invitation.ids.blank?
      @results = []
      @group_invitation.ids.split(',').each do |id|
        if user = User.find_by_id(id) || User.find_by_email(id)
          unless @group.members.include?(user)
            group_invitation = GroupInvitation.find_or_initialize_by_group_id_and_invited_user_id(@group.id, user.id)
            group_invitation.email ||= user.email
          else
            group_invitation = GroupInvitation.new invited_user: user, error: 'already member'
          end
        elsif id =~ /.+@.+\..+/
          group_invitation = GroupInvitation.find_or_initialize_by_group_id_and_email(@group.id, id)
        else
          group_invitation = GroupInvitation.new email: id, error: 'not recognized as valid email'
        end
        group_invitation.error = 'already invited' unless group_invitation.new_record? and group_invitation.error.blank?
        unless group_invitation.error
          group_invitation.message = @group_invitation.message
          if group_invitation.save
            begin
              GroupInvitationMailer.invitation(group_invitation).deliver
            rescue
            end
          end
        end
        puts group_invitation.inspect
        @results << group_invitation
      end
    else
      redirect_to @group
    end
  end
end
