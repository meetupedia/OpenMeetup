class UninterestsController < CommonController
  load_resource
  authorize_resource

  def index
    type = params[:uninterestable_type]
    @uninterests = current_user.uninterests.order('id DESC').includes(:uninterestable)
    @uninterests = @uninterests.where(uninterestable_type: type) if type.present?
    @uninterests = @uninterests.paginate page: params[:page]
    @title = 'Érdektelennek jelölt ' + case type
      when 'Book' then 'könyvek'
      when 'Campaign' then 'kihívások'
      when 'User' then 'tagok'
      else 'elemek'
    end
  end

  def create
    @uninterest = Uninterest.find_or_create_by_user_id_and_uninterestable_type_and_uninterestable_id(current_user.id, params[:uninterestable_type], params[:uninterestable_id])
  end

  def destroy
    @uninterest.destroy
    destroy_show @uninterest
  end
end
