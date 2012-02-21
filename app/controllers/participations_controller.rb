class ParticipationsController < InheritedResources::Base
  belongs_to :event, :shallow => true
  load_and_authorize_resource :except => [:index, :show]

  def create
    create! { @event }
    create_activity @participation
  end

  def destroy
    destroy! { @event }
  end
end
