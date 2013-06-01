# encoding: UTF-8

class InterestsController < CommonController
  load_resource
  authorize_resource

  def index
    if Interest.count == 0
      redirect_to root_url
    else
      @interests = Interest.order('name ASC')
    end
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
