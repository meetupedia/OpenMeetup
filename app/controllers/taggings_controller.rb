# encoding: UTF-8

class TaggingsController < CommonController
  load_resource :tag
  load_resource :tagging, through: :tag, shallow: true
  authorize_resource

  def create
    unless @tag.tagging_for(current_user)
      @tagging.save
      create_activity @tagging
    end
    redirect_to interests_url unless request.xhr?
  end

  def destroy
    @tagging.destroy
    if request.xhr?
      render :create
    else
      redirect_to interests_url
    end
  end

  def set
    unless @tagging = @tag.tagging_for(current_user)
      @tagging = Tagging.create tag: @tag
      create_activity @tagging
    else
      @tagging.destroy
    end
  end
end
