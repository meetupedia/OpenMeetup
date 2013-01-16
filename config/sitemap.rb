# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://'+Settings.host

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  User.find_each do |user|
    add user_path(user), :lastmod => user.updated_at
  end

  Event.find_each do |event|
    add event_path(event), :lastmod => event.updated_at
  end

  Group.find_each do |group|
    add group_path(group), :lastmod => group.updated_at
  end

  Interest.find_each do |interest|
    add interest_path(interest), :lastmod => interest.updated_at
  end

  City.find_each do |city|
    add city_path(city)
  end

end
