# encoding: UTF-8

class ImagesController < CommonController
  load_resource :event
  load_resource :group
  load_resource :image, through: [:event, :group], shallow: true
  authorize_resource except: [:show, :next, :previous, :upload]

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

  def destroy
    @image.destroy
    if @image.imageable.is_a?(Group)
      redirect_to images_group_path(@image.imageable)
    else
      redirect_to @image.imageable
    end
  end

  def next
    if @image.imageable
      image = @image.imageable.images.where('id > ?', @image.id).order('id ASC').first
      image ||= @image.imageable.images.order('id ASC').first
      redirect_to image
    else
      redirect_to root_path
    end
  end

  def previous
    if @image.imageable
      image = @image.imageable.images.where('id < ?', @image.id).order('id ASC').last
      image ||= @image.imageable.images.order('id ASC').last
      redirect_to image
    else
      redirect_to root_path
    end
  end

  def upload
    @image = Image.new
    @image.imageable = @event || @group
    @image.image = request.body
    if @image.save
      create_activity @image
    else
      render json: {'fail' => true}
    end
  end
end
