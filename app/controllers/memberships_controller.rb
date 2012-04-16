# -*- encoding : utf-8 -*-

class MembershipsController < ApplicationController
  load_resource :group
  load_resource :membership, :through => :group, :shallow => true
  authorize_resource

  def create
    unless @group.membership_for(current_user)
      @membership.save
      create_activity @membership
    end
    redirect_to @group unless request.xhr?
  end

  def destroy
    unless @membership.is_admin? or @membership.group.admins.count > 1
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
end
