# encoding: UTF-8

module CommonHelper

  def current_user
    nil
  end

 
  def can?(*args)
    false
  end

  def application_title
    Settings.title
  end
end
