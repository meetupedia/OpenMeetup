# encoding: UTF-8

class RootController < ApplicationController

  def index
    redirect_to discovery_url if current_user
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
