# -*- encoding : utf-8 -*-

class TagsController < ApplicationController
  load_resource :group
  load_resource :tag, :through => :group, :shallow => true, :except => [:create]
  authorize_resource :except => [:index, :show]

  def show
  end

  def new
    render :layout => false if request.xhr?
  end

  def create
    if @tag = Tag.find_or_create_by_name(params[:tag][:name])
      if @group
        @group.tags << @tag
        redirect_to @group
      else
        redirect_to @tag
      end
    else
      render :new
    end
  end
end
