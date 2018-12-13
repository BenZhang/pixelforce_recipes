namespace :logrotate do
  desc "Setup logrotate configuration for this application"
  task :setup do
    on roles(:app) do
      template "logrotate.erb", "/tmp/logrotate"
      sudo "mv /tmp/logrotate /etc/logrotate.d/#{application}"
    end
  end
end
