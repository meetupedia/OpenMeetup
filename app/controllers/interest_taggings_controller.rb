# encoding: UTF-8

class InterestTaggingsController < CommonController
  load_resource :interest
  load_resource :interest_tagging, :through => :interest, :shallow => true
  authorize_resource
  skip_before_filter :check_restricted_access

  def create
    unless @interest.interest_tagging_for(current_user)
      @interest_tagging.save
      tag = Tag.find_or_create_by_name(@interest.name.trl)
      unless tag.tagging_for(current_user)
        tagging = Tagging.create :tag => tag
        create_activity tagging unless current_user.restricted_access?
      end
    end
    redirect_to interests_url unless request.xhr?
  end

  def destroy
    @interest_tagging.destroy
    Tag.where(:name => @interest_tagging.interest.name.trl).first.andand.tagging_for(current_user).andand.destroy
    if request.xhr?
      render :create
    else
      redirect_to interests_url
    end
  end
end
