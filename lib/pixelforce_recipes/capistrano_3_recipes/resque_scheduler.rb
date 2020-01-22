namespace :resque_scheduler do
  desc "Install resque scheduler"

  desc "Setup resque scheduler configuration for this application"
  task :setup do
    on roles(:resque) do
      template "resque_scheduler_supervisor.erb", "/tmp/resque_scheduler"
      sudo "mv /tmp/resque_scheduler /etc/supervisor/conf.d/resque_scheduler"
      sudo "supervisorctl reread"
      sudo "supervisorctl update" # it will auto start the application
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} resque_scheduler"
    task command do
      on roles(:resque) do
        execute "supervisorctl #{command} resque_scheduler"
      end
    end
  end
end
