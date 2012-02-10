class EventsController < InheritedResources::Base
  belongs_to :group
  load_and_authorize_resource :only => [:new, :create, :edit, :update, :destroy]
end
