# encoding: UTF-8

class NotificationsController < CommonController
  load_resource
  authorize_resource

  def index
    @group = Group.find_by_id(params[:group_id]) if params[:group_id].present?
    @notifications = current_user.notifications.order('created_at DESC')
    @notifications = @notifications.where(:group_id => @group.id) if @group
    @notifications = @notifications.paginate :page => params[:page]
    @last_notified = Time.zone.at(params[:time].to_i) if params[:time].present?
    @last_notified ||= current_user.last_notified
    @notifications_count = current_user.notifications.where('created_at > ?', @last_notified).count
    @counts = Group.joins(:notifications).where('notifications.user_id' => current_user.id).where('notifications.created_at > ?', @last_notified).group('groups.id').count
    current_user.update_attributes :notifications_count => 0, :last_notified => Time.zone.now
  end

  def destroy
    @notification.destroy
    destroy_show @notification
  end
end
