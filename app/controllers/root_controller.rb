# encoding: UTF-8

class RootController < ApplicationController

  def index
    redirect_to discovery_url if current_user
    template = 'custom/root.index.slim'
    render template if File.file?(File.join(Rails.root, 'app/views', template))
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
end
