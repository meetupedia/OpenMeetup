# encoding: UTF-8

class WaveItemsController < CommonController
  load_resource :wave
  load_resource :wave_item, :through => :wave, :shallow => true
  authorize_resource

  def new
  end

  def create
    if @wave_item.save
      redirect_to @wave
    else
      render :new
    end
  end
end
