class EventsController < InheritedResources::Base
  belongs_to :group, :optional => true
  load_resource
  authorize_resource :except => [:index, :show]

  def create
    create!
    create_activity @event
  end
end
