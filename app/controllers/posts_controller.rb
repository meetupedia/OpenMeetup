# encoding: UTF-8

class PostsController < CommonController
  load_resource :group
  load_resource :post, :through => :group, :shallow => true
  authorize_resource

  def new
  end

  def create
    @post.postable = @group if @group
    if @post.save
      create_activity @post
      respond_to do |format|
        format.html { redirect_to @post.postable }
        format.js
      end
    end
  end
end
