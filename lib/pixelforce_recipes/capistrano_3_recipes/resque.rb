namespace :resque do
  desc "Install resque"

  desc "Setup resque configuration for this application"
  task :setup do
    on roles(:resque) do
      template "resque_supervisor.erb", "/tmp/resque"
      sudo "mv /tmp/resque /etc/supervisor/conf.d/resque"
      sudo "supervisorctl reread"
      sudo "supervisorctl update" # it will auto start the application
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} resque"
    task command do
      on roles(:resque) do
        execute "supervisorctl #{command} resque"
      end
    end
  end
end
