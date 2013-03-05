set :job_template, %{bash -l -c "source \\"$HOME/.rvm/scripts/rvm\\" && cd #{path} && :job"}
set :output, {:error => 'log/whenever-error.log'}

# sitemap refresh
every 1.day, :at => '5:00 am' do
  rake 'sitemap:refresh'
end

# git pull and bundle install
every 5.minutes do
  command 'git pull https://github.com/meetupedia/OpenMeetup.git master && bundle install --without test'
end

# whenever update cron
every 5.minutes do
  command 'whenever --update-crontab'
end

# i am still alive?
# every 5.minutes do
#   command 'tail -n 1000 log/production.log > log/test.log'
#   runner "TestMailer.report('debug@meetupedia.org').deliver"
# end

# creating crash
# every 5.minutes do
#   command 'wget http://get2gather.eth.ericsson.se/crash'
#   command 'wget http://meetupedia.com/crash'
# end
