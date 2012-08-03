# encoding: UTF-8

class InterestTaggingsController < ApplicationController
  load_resource :interest
  load_resource :invited_interest_tagging, :through => :interest, :shallow => true, :except => [:destroy]
  authorize_resource

  def create
    unless @interest.invited_interest_tagging_for(params[:code])
      @invited_interest_tagging.code = params[:code]
      @invited_interest_tagging.save
    end
    redirect_to interests_url unless request.xhr?
  end

  def destroy
    @invited_interest_tagging.destroy
    if request.xhr?
      render :create
    else
      redirect_to interests_url
    end
  end
end
