class Admin::UsersController < ApplicationController
  before_filter :can_admin?
  load_resource

  def index
    @users = User.order('created_at DESC').paginate :page => params[:page]
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end
end
