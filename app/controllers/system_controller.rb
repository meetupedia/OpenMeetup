# encoding: UTF-8

class SystemController < CommonController
  before_filter :authenticate_as_admin

  def index
  end

  def reload
    system "script/reload_from_browser"
    redirect_to system_url
  end

  def download_database
    system "script/backup"
    send_file 'db/openmeetup.sql'
  end

protected

  def authenticate_as_admin
    raise CanCan::AccessDenied unless current_user.andand.is_admin?
  end
end
