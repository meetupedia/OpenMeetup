class MembershipsController < InheritedResources::Base
  belongs_to :group, :shallow => true
  load_and_authorize_resource :except => [:index, :show]

  def create
    create! { @group }
    create_activity @membership
  end

  def destroy
    destroy! { @group }
  end
end
