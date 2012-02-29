class GroupsController < InheritedResources::Base
  load_resource
  authorize_resource :except => [:index, :show]

  def create
    create!
    create_activity @group
  end

  def set_membership
    membership = Membership.find_or_initialize_by_group_id_and_user_id(@group.id, current_user.id)
    if membership.new_record?
      membership.save
      create_activity membership
    elsif params[:protection].blank?
      unless membership.is_admin? or @group.admins.count > 1
        membership.destroy
      else
        flash[:alert] = 'Nem törölheted magad, ha nincsen legalább két admin!'
      end
    end
    redirect_to @group
  end
end
