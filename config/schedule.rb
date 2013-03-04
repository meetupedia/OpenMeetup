set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

# sitemap refresh
every 1.day, :at => '5:00 am' do
  rake "sitemap:refresh"
end

# git pull
# every '0,15,30,45 * * * *' do  
every 5.minutes do
  command "cd #{path} && git pull https://github.com/meetupedia/OpenMeetup.git master"
end

# bundle install
# every '5,20,35,50 * * * *' do
every 5.minutes do
  command "source \"$HOME/.rvm/scripts/rvm\" && cd #{path} && bundle install"
end

# whenever update cron
# every '10,25,40,55 * * * *' do
every 5.minutes do
  command "source \"$HOME/.rvm/scripts/rvm\" && cd #{path} && whenever --update-crontab"
end

# i am still alive?
# every 10.minutes do
#  runner 'UserMailer.set_admin(User.find_by_email("andris@szimpatikus.hu")).deliver'
# end

every 5.minutes do
  command "source \"$HOME/.rvm/scripts/rvm\" && cd #{path} && script/rails runner \"TestMailer.report('bence.nagy@gmail.com').deliver\""
end
