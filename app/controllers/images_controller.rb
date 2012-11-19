# encoding: UTF-8

class ImagesController < CommonController
  load_resource :event
  load_resource :group
  load_resource :image, :through => [:event, :group], :shallow => true
  authorize_resource

  def create
    @image = Image.new(coerce(params)[:image])
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

protected

  def coerce(params)
    if params[:image].nil?
      hash = {}
      hash[:image] = {}
      hash[:image][:image] = params[:Filedata]
      hash[:image][:image].content_type = MIME::Types.type_for(hash[:image][:image].original_filename).to_s
      hash
    else
      params
    end
  end
end
