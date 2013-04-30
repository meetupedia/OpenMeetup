# encoding: UTF-8

class FeedbacksController < CommonController
  load_resource
  authorize_resource :except => [:create]

  def index
    @feedbacks = Feedback.order('created_at DESC').paginate :page => params[:page]
  end

  def create
    @feedback.save
    User.where(:is_admin => true).each do |user|
      AdminMailer.feedback(@feedback, user).deliver
    end
  end
end
