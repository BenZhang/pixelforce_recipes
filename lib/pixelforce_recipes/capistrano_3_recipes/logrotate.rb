namespace :logrotate do
  desc "Setup logrotate configuration for this application"
  task :setup do
    on roles(:web) do
      template "logrotate.erb", "/tmp/logrotate"
      sudo "mv /tmp/logrotate /etc/logrotate.d/#{fetch(:application)}"
      sudo "chown root:root /etc/logrotate.d/#{fetch(:application)}"
    end
  end
end
