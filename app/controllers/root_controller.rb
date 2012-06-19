# -*- encoding : utf-8 -*-

class RootController < ApplicationController

  def index

    # ha szervezet
    if @organization = current_organization

      # ha szervezet + be van lépve
      if current_user
        @title = @organization.name
        render 'organizations/show'


	  # ha szervezet + nincs belépve
      else
      end

	# ha nem szervezet + be van lépve
    elsif current_user
      redirect_to tag_myself_url

	# ha nem szervezet + nincs belépve
    else
    end

  end

  def intro
    render :index
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
