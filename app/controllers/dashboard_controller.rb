# encoding: UTF-8

class DashboardController < CommonController
  before_filter :authenticate_as_admin

  def index
  end

  def city_groups
    @cities = City.joins(:groups).order('name ASC').group('cities.id').all
  end

  def city_users
    @cities = City.joins(:users).order('name ASC').group('cities.id').all
  end

  def events
  end

  def groups
  end

  def interests
  end

  def members
  end

  def notifications
    @activities = Activity.order('created_at DESC').paginate page: params[:page]
  end

  def reload
    system 'script/reload_from_browser'
    redirect_to system_url
  end

  def download_database
    system 'script/backup'
    send_file 'tmp/openmeetup.sql'
  end

  def download_translations
    system 'script/backup_translations'
    send_file 'tmp/translations.sql'
  end
end
