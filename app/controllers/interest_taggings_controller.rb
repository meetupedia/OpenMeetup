# -*- encoding : utf-8 -*-

class InterestTaggingsController < ApplicationController
  load_resource :interest
  load_resource :interest_tagging, :through => :interest, :shallow => true
  authorize_resource

  def create
    unless @interest.interest_tagging_for(current_user)
      @interest_tagging.save
      tag = Tag.find_or_create_by_name_and_language_id(@interest.name.trl, Language.find_by_code(I18n.locale))
      unless tag.tagging_for(current_user)
        tagging = Tagging.create :tag => tag
        create_activity tagging
      end
    end
    redirect_to interests_url unless request.xhr?
  end

  def destroy
    @interest_tagging.destroy
    if tag = Tag.find_by_name_and_language_id(@interest_tagging.interest.name.trl, Language.find_by_code(I18n.locale))
      tag.tagging_for(current_user).andand.destroy
    end
    if request.xhr?
      render :create
    else
      redirect_to interests_url
    end
  end
end