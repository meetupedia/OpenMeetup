# encoding: UTF-8

class SettingsController < CommonController
  load_resource
  authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @setting.save
      redirect_to settings_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @setting.update_attributes params[:setting]
      redirect_to settings_url
    else
      render :edit
    end
  end

  def destroy
    @setting.destroy
    redirect_to settings_url
  end
end
