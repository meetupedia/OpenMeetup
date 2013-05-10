# encoding: UTF-8

class VotesController < CommonController
  load_resource
  authorize_resource :except => [:index]

  def index
    @voteable = Vote.find_by_voteable_type_and_voteable_id(params[:voteable_type], params[:voteable_id]).andand.voteable
    redirect_to root_url unless @voteable and request.xhr?
  end

  def set
    @vote = Vote.find_or_initialize_by_voteable_type_and_voteable_id_and_user_id(params[:voteable_type], params[:voteable_id], current_user.id)
    if @vote.voteable
      if @vote.new_record?
        @vote.save
        create_activity @vote
      else
        @vote.destroy
      end
      if request.xhr?
        render :partial => 'votes/set', :locals => {:item => @vote.voteable.reload}
      else
        redirect_to @vote.voteable
      end
    else
      render :nothing => true
    end
  end
end
