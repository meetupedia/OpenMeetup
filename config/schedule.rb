# load rails
require File.expand_path(File.dirname(__FILE__) + "/environment") 

# set path
env :PATH, ENV['PATH']
env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'

# sitemap refresh
every 1.day, :at => '5:00 am' do
  rake "sitemap:refresh"
end

# git pull
every '0,15,30,45 * * * *' do  
  command "cd #{path} && git pull https://github.com/meetupedia/OpenMeetup.git"
end

# bundle install
every '5,20,35,50 * * * *' do
  command "cd #{path} && bundle install"
end

# whenever update cron
every '10,25,40,55 * * * *' do
  command "cd #{path} && whenever --update-crontab"
end

# i am still alive?
every 5.minutes do
  runner 'UserMailer.set_admin(User.find_by_email("andris@szimpatikus.hu")).deliver'
end
