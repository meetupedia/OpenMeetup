require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
  end

  test 'should get show' do
    get :show, :id => @group.id
    assert_response :success
  end
end