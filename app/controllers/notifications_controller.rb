# encoding: UTF-8

class NotificationsController < CommonController
  load_resource
  authorize_resource

  def index
    @group = Group.find_by_id(params[:group_id]) if params[:group_id].present?
    @notifications = current_user.notifications.order('created_at ASC')
    @notifications = @notifications.where(:group_id => @group.id) if @group
    @notifications = @notifications.paginate :page => params[:page]
  end

  def destroy
    @notification.destroy
    destroy_show @notification
  end
end
