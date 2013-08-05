# encoding: UTF-8

class FeedbacksController < CommonController
  load_resource
  authorize_resource

  def index
    @feedbacks = Feedback.order('created_at DESC').paginate page: params[:page]
  end

  def create
    @feedback.save
    User.where(is_admin: true).each do |user|
      AdminMailer.feedback(@feedback.id, user.id, current_user.id, request.url).deliver
    end
    respond_to do |format|
      format.js
      format.html do
        redirect_to root_url, notice: 'Thank you, we appreciate your feedback!'
      end
    end
  end
end
