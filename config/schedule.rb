set :job_template, %{bash -l -c "source \\"$HOME/.rvm/scripts/rvm\\" && cd #{path} && :job"}
set :output, error: 'log/whenever-error.log'

# weekly report
every :sunday, at: '8:00pm' do
  runner 'Admin.weekly_newsletter'
end

# daily jobs
every 1.day, at: '5:00am' do
  runner 'Admin.cron_daily'
  # rake 'sitemap:create'
  runner 'SitemapGenerator::Interpreter.run'
end

# hrourly jobs
every 1.hour do
  runner 'Minion.run'
end

# restart halted mailman
every 10.minutes do
  command './restart_mailman.sh'
end
