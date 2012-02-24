module ApplicationHelper

  def user_avatar(user)
    filename = case user.provider
      when 'facebook' then "https://graph.facebook.com/#{user.uid}/picture"
      else 'default_avatar.png'
    end
    link_to(image_tag(filename, :alt => user.name, :height => 32, :width => 32), user)
  end

#  def gmaps4rails(builder, enable_css = true, enable_js = true)
#    options = {
#      :map_options => {:auto_adjust => true, :auto_zoom => false, :zoom => 15},
#      :markers => {:data => builder, :options => {:do_clustering => true}}
#    }
#    render :partial => '/gmaps4rails/gmaps4rails', :locals => {:options => options.with_indifferent_access, :enable_css => enable_css, :enable_js => enable_js}
#  end
end
