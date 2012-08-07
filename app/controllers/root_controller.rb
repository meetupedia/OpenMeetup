# encoding: UTF-8

class RootController < CommonController
  skip_before_filter :check_restricted_access, :only => [:index, :restricted_access]

  def index
    if current_user
      unless current_user.restricted_access
        redirect_to discovery_url
      else
        redirect_to restricted_access_url
      end
    else
      template = 'custom/root.index.slim'
      render template if File.file?(File.join(Rails.root, 'app/views', template))
    end
  end

  def intro
    render :index
  end

  def about
  end

  def developer_dashboard
  end

  def dashboard
  end

  def restricted_access
  end
end
