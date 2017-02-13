set :output, "/var/log/makigas.cron.log"

every :day, at: '5am' do
  rake '-s sitemap:refresh'
end