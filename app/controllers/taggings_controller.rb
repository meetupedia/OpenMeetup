# -*- encoding : utf-8 -*-

class TaggingsController < ApplicationController
  load_resource :tag
  load_resource :tagging, :through => :tag, :shallow => true
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
end
