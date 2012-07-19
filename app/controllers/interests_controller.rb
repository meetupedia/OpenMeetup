# encoding: UTF-8

class InterestsController < ApplicationController
  load_resource
  authorize_resource

  def create
    @interest.save
    redirect_to tag_myself_url
  end

  def edit
  end

  def update
    @interest.update_attributes params[:interest]
    redirect_to tag_myself_url
  end
end
