SitemapGenerator::Sitemap.default_host = 'http://' + Settings.host

SitemapGenerator::Sitemap.create do
  User.find_each do |user|
    add user_path(user), lastmod: user.updated_at
  end

  Event.find_each do |event|
    add event_path(event), lastmod: event.updated_at
  end

  Group.find_each do |group|
    add group_path(group), lastmod: group.updated_at
  end

  Interest.find_each do |interest|
    add interest_path(interest), lastmod: interest.updated_at
  end

  City.find_each do |city|
    add city_path(city)
  end
end
