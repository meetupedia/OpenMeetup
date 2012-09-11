# encoding: UTF-8

class CommentsController < CommonController
  load_resource :post
  load_resource :comment, :through => :post, :shallow => true
  authorize_resource

  def new
  end

  def create
    @comment.commentable = @post
    if @comment.save
      create_activity @comment
      respond_to do |format|
        format.html { redirect_to @post.postable }
        format.js
      end
    end
  end
end
