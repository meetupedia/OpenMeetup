# encoding: UTF-8

class DashboardController < CommonController
  before_filter :authenticate_as_admin

  def index
  end

  def reload
    system "script/reload_from_browser"
    redirect_to system_url
  end

  def download_database
    system "script/backup"
    send_file 'tmp/openmeetup.sql'
  end

  def download_translations
    system "script/backup_translations"
    send_file 'tmp/translations.sql'
  end

protected

  def authenticate_as_admin
    raise CanCan::AccessDenied unless current_user.andand.is_admin?
  end
end
