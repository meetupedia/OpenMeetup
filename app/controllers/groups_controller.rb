class GroupsController < InheritedResources::Base
  load_and_authorize_resource :only => [:new, :create, :edit, :update, :destroy]

  def create
    create! do
      create_activity @group
      @group
    end
  end
end
