# -*- encoding : utf-8 -*-

class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:show, :groups]

  def show
  end

  def edit
    render :layout => false if request.xhr?
  end

  def update
    @user.update_attributes params[:user]
    redirect_to @user
  end

  def dashboard
    @admined_groups = @user.admined_groups
  end

  def groups
    @groups = @user.joined_groups.paginate :page => params[:page]
  end

  def facebook_groups
    @facebook_groups = @user.facebook.groups
  end

  def waves
    @waves = current_user.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end

  def tags

  end
end
