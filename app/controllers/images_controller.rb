# encoding: UTF-8

class ImagesController < CommonController
  load_resource :event
  load_resource :group
  load_resource :image, :through => [:event, :group], :shallow => true
  authorize_resource :except => [:show, :next, :previous, :upload]

  def create
    @image.imageable = @event || @group
    if @image.save
      create_activity @image
      respond_to do |format|
        format.html do
          if @image.is_live?
            redirect_to actual_event_path(@image.imageable)
          else
            redirect_to @image.imageable
          end
        end
        format.js
      end
    end
  end

  def next
    image = @image.imageable.images.where('id > ?', @image.id).order('id ASC').first
    image ||= @image.imageable.images.order('id ASC').first
    redirect_to image
  end

  def previous
    image = @image.imageable.images.where('id < ?', @image.id).order('id ASC').last
    image ||= @image.imageable.images.order('id ASC').last
    redirect_to image
  end

  def upload
    @image = Image.new
    @image.imageable = @event || @group
    @image.image = request.body
    if @image.save
      create_activity @image
    else
      render :json => {'fail' => true}
    end
  end
end
