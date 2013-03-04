set :job_template, "source \"$HOME/.rvm/scripts/rvm\" && cd #{path} && :job"
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}

# sitemap refresh
every 1.day, :at => '5:00 am' do
  rake 'sitemap:refresh'
end

# git pull and bundle install
every 5.minutes do
  command 'git pull https://github.com/meetupedia/OpenMeetup.git master && bundle install'
end

# whenever update cron
every 5.minutes do
  command 'whenever --update-crontab'
end

# i am still alive?
every 5.minutes do
  runner "TestMailer.report('debug@meetupedia.org').deliver"
end
