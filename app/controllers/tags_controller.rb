# -*- encoding : utf-8 -*-

class TagsController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show]

  def show
  end

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @tag.save
      redirect_to @tag
    else
      render :new
    end
  end
end
