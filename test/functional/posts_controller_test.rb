require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:group_one)
    @user = users(:user_one)
  end

  test 'create without sign in' do
    assert_raise CanCan::AccessDenied do
      post :create, post: {post: 'Test'}, group_id: @group.id
    end
  end

#  test 'create with sign in' do
#    UserSession.create(users(:user_one))
#    assert_difference('Post.count') do
#      post :create, post: {post: 'Test'}, group_id: @group.id
#    end
#    assert_redirected_to group_path(@group)
#  end

end
