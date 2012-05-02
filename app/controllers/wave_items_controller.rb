# encoding: UTF-8

class WaveItemsController < ApplicationController
  load_resource :wave
  load_resource :wave_item, :through => :wave, :shallow => true
  authorize_resource

  def new
    render :layout => false if request.xhr?
  end

  def create
    @wave_item.save
    redirect_to @wave
  end
end
