require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:group_one)
    @event = events(:event_one)
  end

  test 'show' do
    get :show, :id => @event.id
    assert_response :success
  end
end
