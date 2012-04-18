# encoding: UTF-8

class WaveItemsController < ApplicationController
  load_resource :wave
  load_resource :wave_item, :through => :wave, :shallow => true
  authorize_resource

  def create
    @wave_item.save
    if request.xhr?
      render :layout => false
    else
      redirect_to @wave
    end
  end
end
