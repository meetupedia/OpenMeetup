# encoding: UTF-8

class CommentsController < CommonController
  load_resource :event
  load_resource :group
  load_resource :comment, :through => [:event, :group], :shallow => true
  authorize_resource

  def create
    @comment.commentable = @event if @event
    @comment.commentable = @group if @group
    if @comment.save
      create_activity @comment
      respond_to do |format|
        format.html { redirect_to @comment.commentable }
        format.js
      end
    end
  end
end
