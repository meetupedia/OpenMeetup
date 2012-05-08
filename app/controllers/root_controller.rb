# -*- encoding : utf-8 -*-

class RootController < ApplicationController

  def index
    if @organization = current_organization
      if current_user
        @title = @organization.name
        render 'organizations/show'
      else
        @header = 'root/index_header'
      end
    elsif current_user
      redirect_to tag_myself_url
    else
      @header = 'root/index_header'
    end
  end

  def tag_myself
    redirect_to root_url unless current_user
  end

  def about
  end

  def developer_dashboard
  end

  def dashboard
  end
end
