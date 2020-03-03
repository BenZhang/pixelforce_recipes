namespace :logrotate do
  desc "Setup supervisor configuration for this application"
  task :setup do
    on roles(:app) do
      template "supervisor.erb", "/tmp/supervisor"
      sudo "mv /tmp/supervisor /etc/supervisor/supervisord.conf"
    end
  end
end
