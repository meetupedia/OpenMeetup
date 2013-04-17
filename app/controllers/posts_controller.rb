# encoding: UTF-8

class PostsController < CommonController
  load_resource :event
  load_resource :group
  load_resource :post, :through => [:event, :group], :shallow => true
  authorize_resource :except => [:show]

  def show
  end

  def new
  end

  def create
    @post.postable = @event || @group
    if @post.save
      create_activity @post
      if @event
        (@event.participants - [@post.user]).each do |user|
          begin
            PostMailer.notification(@post, user).deliver
          rescue
          end
        end
      elsif @group
        (@group.members - [@post.user]).each do |user|
          begin
            PostMailer.notification(@post, user).deliver
          rescue
          end
        end
      end
      respond_to do |format|
        format.html do
          if @post.event
            redirect_to actual_event_path(@post.event)
          else
            redirect_to @post.postable
          end
        end
        format.js
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html do
        redirect_to @post.postable
      end
      format.js
    end
  end
end
