class Admin::UsersController < ApplicationController
  before_filter :can_admin?
  load_resource

  def index
    @users = User.paginate page: params[:page]
    order = case params[:order]
      when 'id' then 'id ASC'
      when 'name' then 'name ASC'
      when 'email' then 'email ASC'
      else 'id ASC'
    end
    @users = @users.order(order)
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end
end
