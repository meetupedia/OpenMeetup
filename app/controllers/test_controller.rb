class TestController < CommonController

  def index
    @user = User.first
  end
end
