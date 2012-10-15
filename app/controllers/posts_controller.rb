# encoding: UTF-8

class PostsController < CommonController
  load_resource :group
  load_resource :post, :through => :group, :shallow => true
  authorize_resource :except => [:show]

  def show
  end

  def new
  end

  def create
    @post.postable = @group if @group
    if @post.save
      create_activity @post
      if @group
        run_later do
          @group.members.each do |user|
            PostMailer.notification(@post, user).deliver if user.email
          end
        end
      end
      respond_to do |format|
        format.html { redirect_to @post.postable }
        format.js
      end
    end
  end
end
