require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = images(:image_one)
  end

  test 'show without sign in' do
    get :show, :id => @image.id
    assert_response :success
  end

  test 'show with sign in' do
    UserSession.create(users(:user_one))
    get :show, :id => @image.id
    assert_response :success
  end
end
