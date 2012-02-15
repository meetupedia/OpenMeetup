class GroupsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index, :show]

  def create
    create!
    create_activity @group
  end
end
