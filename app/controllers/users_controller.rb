# -*- encoding : utf-8 -*-

class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show, :groups, :validate_email]
  before_filter :set_city, :except => [:edit, :update, :edit_city]

  def index
    @users = User.where('name LIKE ?', "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @users.map { |user| {:id => user.id, :name => user.name} } }
    end
  end

  def show
  end

  def new
  end

  def create
    if @user.save
      redirect_to discovery_url
    else
      render :new
    end
  end

  def edit
    render :layout => false if request.xhr?
  end

  def update
    @user.update_attributes params[:user]
    redirect_to @user
  end

  def dashboard
  end

  def edit_city
    render :layout => false if request.xhr?
  end

  def groups
    @groups = @user.joined_groups.paginate :page => params[:page]
    @admined_groups = @user.admined_groups
  end

  def facebook_groups
    @facebook_groups = @user.facebook.groups
  end

  def tags
  end

  def validate_email
    render :json => !User.find_by_email(params[:user][:email])
  end

  def waves
    @waves = current_user.waves.order('last_changed_at DESC').paginate :page => params[:page]
  end
end
