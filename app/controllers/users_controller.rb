# -*- encoding : utf-8 -*-

class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:show, :groups]

  def show
  end

  def dashboard
    @admined_groups = @user.admined_groups
  end

  def groups
    @groups = @user.joined_groups.paginate :page => params[:page]
  end
end
