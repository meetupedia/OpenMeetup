# -*- encoding : utf-8 -*-

class RootController < ApplicationController

  def index
    if current_user
      redirect_to tag_myself_url
    else
      @header = 'root/index_header'
    end
  end

  def tag_myself
  end

  def about
  end

  def developer_dashboard
  end
end
