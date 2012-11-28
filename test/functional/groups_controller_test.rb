require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
  end

  test 'show' do
    get :show, :id => @group.id
    assert_response :success
  end

  test 'new without sign in' do
    get :new
    assert_response 302
  end

  test 'new with sign in' do
    UserSession.create(users(:one))
    get :new
    assert_response :success
  end

  test 'create without sign in' do
    post :create, :group => {:name => 'one'}
    assert_response 302
  end

  test 'create with sign in' do
    UserSession.create(users(:one))
    assert_difference('Group.count') do
      post :create, :group => {:name => 'one'}
    end
    assert_redirected_to group_path(assigns(:group))
  end

  test 'edit without sign in' do
    get :edit, :id => @group.id
    assert_response 302
  end

  test 'edit with sign in and without membership'  do
    UserSession.create(users(:one))
    get :edit, :id => @group.id
    assert_response 302
  end

  test 'edit with sign in and plain membership' do
    UserSession.create(users(:one))
    membership = Membership.create :group => @group, :user => users(:one)
    get :edit, :id => @group.id
    assert_response 302
  end

  test 'edit with sign in and admin membership' do
    UserSession.create(users(:one))
    membership = Membership.create :group => @group, :user => users(:one)
    membership.is_admin = true
    membership.save
    get :edit, :id => @group.id
    assert_response :success
  end
end
