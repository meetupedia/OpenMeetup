# encoding: UTF-8

class RootController < ApplicationController

  def index
    redirect_to discovery_path
  end

  def intro
    render :index
  end

  def tag_myself
    redirect_to discovery_path unless current_user
  end

  def about
  end

  def developer_dashboard
  end

  def dashboard
  end
end
