# encoding: UTF-8

class CommentsController < CommonController
  load_resource :image
  load_resource :post
  load_resource :comment, :through => [:image, :post], :shallow => true
  authorize_resource

  def new
  end

  def create
    @comment.commentable = @image || @post
    @group = @post.postable if @psot and @post.postable.is_a?(Group)
    if @comment.save
      create_activity @comment
      if @group
        run_later do
          @group.members.each do |user|
            CommentMailer.notification(@comment, user).deliver if user.email
          end
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
