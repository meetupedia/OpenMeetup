# -*- encoding : utf-8 -*-

class ImagesController < ApplicationController
  load_resource :event
  load_resource :group
  load_resource :image, :through => [:event, :group], :shallow => true
#  authorize_resource

  def create
    @image = Image.new(coerce(params)[:image])
    @image.imageable = @event if @event
    @image.imageable = @group if @group
    if @image.save
      respond_to do |format|
        format.html { redirect_to @image.imageable }
        format.js
      end
    end
  end

protected

  def coerce(params)
    if params[:image].nil?
      h = Hash.new
      h[:image] = Hash.new
      h[:image][:image] = params[:Filedata]
      h[:image][:image].content_type = MIME::Types.type_for(h[:image][:image].original_filename).to_s
      h
    else
      params
    end
  end
end
