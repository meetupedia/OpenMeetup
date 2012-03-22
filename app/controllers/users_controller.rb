# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:show]

  def show
  end

  def dashboard
    @admined_groups = @user.admined_groups
  end
end
