# encoding: UTF-8

class InterestsController < CommonController
  load_resource
  authorize_resource
  skip_before_filter :check_restricted_access

  def index
    redirect_to root_url if Interest.count == 0
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
