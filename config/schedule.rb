set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

# sitemap refresh
every 1.day, :at => '5:00 am' do
  rake "sitemap:refresh"
end

# git pull
# every '0,15,30,45 * * * *' do  
every 5.minutes do
  command "cd :path && git pull https://github.com/meetupedia/OpenMeetup.git master"
end

# bundle install
# every '5,20,35,50 * * * *' do
every 5.minutes do
  command "source \"$HOME/.rvm/scripts/rvm\" && cd :path && bundle install"
end

# whenever update cron
# every '10,25,40,55 * * * *' do
every 5.minutes do
  command "source \"$HOME/.rvm/scripts/rvm\" && cd :path && whenever --update-crontab"
end

# i am still alive?
# every 1.day, :at => '15:45' do
#  runner 'User.set_admin(User.find_by_email("eva.turi@ericsson.com"))'
# end

# i am still alive?
# every 5.minutes, :at => '15:45' do
#  runner 'UserMailer.set_admin(User.find_by_email("andris@szimpatikus.hu")).deliver'
# end
