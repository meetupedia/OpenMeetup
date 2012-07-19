# encoding: UTF-8

class RootController < ApplicationController
  before_filter :authenticate, :only => [:tag_myself]

  def index
    redirect_to discovery_url
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

  def tag_myself
  end
end
