module ApplicationHelper

  def user_avatar(user)
    filename = case user.provider
      when 'facebook' then "https://graph.facebook.com/#{user.uid}/picture"
      else 'default_avatar.png'
    end
    link_to(image_tag(filename, :alt => user.name, :height => 32, :width => 32, :title => user.name), user)
  end

  def sign_in_path(path = nil)
    provider = Rails.env == 'development' ? 'developer' : 'facebook'
    if path
      "/sign_in/#{provider}?return_to=#{path}"
    else
      "/auth/#{provider}"
    end
  end

  def dot
    ' · '
  end
end
