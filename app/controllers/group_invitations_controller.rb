# -*- encoding : utf-8 -*-

class GroupInvitationsController < ApplicationController
  load_resource :group
  load_resource :group_invitation, :through => :group, :shallow => true
  authorize_resource :except => [:index, :show, :users]

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @group_invitation.save
      @group_invitation.emails.split(/\n/).each do |email|
        group_invitation_target = GroupInvitationTarget.find_or_initialize_by_group_id_and_email(@group.id, email)
        if group_invitation_target.new_record?
          group_invitation_target.group_invitation = @group_invitation
          if group_invitation_target.save
            GroupMailer.invitation(group_invitation_target.email, group_invitation_target.group_invitation.group, group_invitation_target.group_invitation.message).deliver
          end
        end
      end
      redirect_to @group, :notice => 'Meghívó elküldve.'
    else
      render :new
    end
  end
end
