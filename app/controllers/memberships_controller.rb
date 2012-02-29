class MembershipsController < InheritedResources::Base
  belongs_to :group, :optional => true
  load_resource
  authorize_resource :except => [:index, :show]

  def create
    create! { @group }
    create_activity @membership
  end

  def destroy
    unless @membership.is_admin? or @group.admins.count > 1
      destroy! { @group }
    else
      redirect_to @group, :alert => 'Nem törölheted magad, ha nincsen legalább két admin!'
    end
  end
end
