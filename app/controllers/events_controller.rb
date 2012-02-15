class EventsController < InheritedResources::Base
  belongs_to :group, :shallow => true
  load_and_authorize_resource :except => [:index, :show]

  def create
    create!
    create_activity @event
  end
end
