# encoding: UTF-8

class WaveMembershipsController < ApplicationController
  load_resource :wave
  load_resource :wave_membership, :through => :wave, :shallow => true
  authorize_resource

  def show
    redirect_to @wave
  end

  def create
    if params[:wave_membership] and not params[:wave_membership][:user_id].blank? and user = User.find_by_id(params[:wave_membership][:user_id])
      @wave_membership = WaveMembership.find_or_create_by_wave_id_and_user_id(@wave.id, user.id) unless user.blocked_user_ids.include?(current_user.id)
    end
    if request.xhr?
      @wave.reload
      render :partial => 'users'
    else
      redirect_to @wave
    end
  end

  def update
    @wave_membership.update_attributes params[:wave_membership]
    redirect_to @wave_membership.wave
  end

  def destroy
    @wave_membership.destroy
    redirect_to waves_url
  end

  def set_archive
    @wave_membership.update_attribute :is_archived, !@wave_membership.is_archived?
    render :partial => 'set_archive', :locals => {:wave => @wave_membership.wave}
  end

  def set_delete
    @wave_membership.update_attribute :is_deleted, !@wave_membership.is_deleted?
    render :nothing => true
  end

  def set_star
    @wave_membership.update_attribute :is_starred, !@wave_membership.is_starred?
    render :partial => 'set_star', :locals => {:wave => @wave_membership.wave}
  end
end
