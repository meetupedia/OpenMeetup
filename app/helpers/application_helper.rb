module ApplicationHelper

  def user_avatar(user)
    filename = case user.provider
      when 'facebook' then "https://graph.facebook.com/#{user.uid}/picture"
      else 'default_avatar.png'
    end
    link_to(image_tag(filename, :alt => user.name, :height => 32, :width => 32), user)
  end
end
