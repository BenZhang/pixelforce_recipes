namespace :resque do
  desc "Install resque"

  desc "Setup resque configuration for this application"
  namespace :sysvinit do
    task :setup do
      on roles(:resque) do
        template "resque_init.erb", "/tmp/resque"
        sudo "mv /tmp/resque /etc/init.d/resque"
        sudo "chmod +x /etc/init.d/resque"
        sudo "update-rc.d resque defaults"
      end
    end

    %w[start stop restart].each do |command|
      desc "#{command} resque"
      task command do
        on roles(:resque) do
          execute "/etc/init.d/resque #{command}"
        end
      end
    end
  end
  namespace :supervisor do
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
end
