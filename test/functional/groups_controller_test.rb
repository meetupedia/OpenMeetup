require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:group_one)
  end

  test 'show' do
    get :show, id: @group.id
    assert_response :success
  end

  test 'new without sign in' do
    assert_raise CanCan::AccessDenied do
      get :new
    end
  end

  test 'new with sign in' do
    UserSession.create(users(:user_one))
    get :new
    assert_response :success
  end

  test 'create without sign in' do
    assert_raise CanCan::AccessDenied do
      post :create, group: {name: 'Testgroup 3', permaname: 'testgroup-3'}
    end
  end

  test 'create with sign in' do
    UserSession.create(users(:user_one))
    assert_difference('Group.count') do
      post :create, group: {name: 'Testgroup 4', permaname: 'testgroup-4'}
    end
    assert_redirected_to group_path(assigns(:group))
  end

  test 'edit without sign in' do
    assert_raise CanCan::AccessDenied do
      get :edit, id: @group.id
    end
  end

  test 'edit with sign in and without membership'  do
    UserSession.create(users(:user_one))
    assert_raise CanCan::AccessDenied do
      get :edit, id: @group.id
    end
  end

  test 'edit with sign in and plain membership' do
    UserSession.create(users(:user_one))
    membership = Membership.create group: @group, user: users(:user_one)
    assert_raise CanCan::AccessDenied do
      get :edit, id: @group.id
    end
  end

  test 'edit with sign in and admin membership' do
    UserSession.create(users(:user_two))
    membership = Membership.create group: @group, user: users(:user_two)
    membership.is_admin = true
    membership.save
    get :edit, id: @group.id
    assert_response :success
  end
end
