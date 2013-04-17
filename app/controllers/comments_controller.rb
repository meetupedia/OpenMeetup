# encoding: UTF-8

class CommentsController < CommonController
  load_resource :activity
  load_resource :image
  load_resource :post
  load_resource :comment, :through => [:activity, :image, :post], :shallow => true
  authorize_resource

  def new
  end

  def create
    @comment.commentable = @activity || @image || @post
    if @comment.save
      create_activity @comment
      if @activity
        ([@activity.user] - [@comment.user]).uniq.each do |user|
          CommentMailer.notification(@comment, user).deliver if user.email
        end
      elsif @post
        (@post.commenters + [@post.user] - [@comment.user]).uniq.each do |user|
          CommentMailer.notification(@comment, user).deliver if user.email
        end
      end
      respond_to do |format|
        format.html { redirect_to @post.postable }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.commentable }
      format.js
    end
  end
end
