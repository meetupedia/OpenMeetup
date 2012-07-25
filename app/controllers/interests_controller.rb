# encoding: UTF-8

class InterestsController < ApplicationController
  load_resource
  authorize_resource

  def index
    redirect_to discovery_url if Interest.count == 0
  end

  def create
    @interest.save
    redirect_to interests_url
  end

  def edit
  end

  def update
    @interest.update_attributes params[:interest]
    redirect_to interests_url
  end
end
