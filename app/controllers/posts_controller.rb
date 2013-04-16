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
    @post.event = Event.find_by_id(params[:post][:event_id])
    @post.postable = @group if @group
    if @post.save
      create_activity @post
      if @group
        run_later do
          @group.members.each do |user|
            begin
              PostMailer.notification(@post, user).deliver
            rescue
            end
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
end
