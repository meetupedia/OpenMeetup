class InvitedUsersController < ApplicationController
  load_resource
  authorize_resource :except => [:new, :create]

  def new
  end

  def create
    @invited_user.locale = current_locale
    @invited_user.save
    redirect_to @invited_user
  end

  def show
  end
end
