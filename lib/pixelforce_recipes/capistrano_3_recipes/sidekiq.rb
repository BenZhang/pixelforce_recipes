namespace :sidekiq do
  desc "Install sidekiq"

  desc "Setup sidekiq configuration for this application"
  namespace :sysvinit do
    task :setup do
      on roles(:sidekiq) do
        template "sidekiq_init.erb", "/tmp/sidekiq"
        sudo "mv /tmp/sidekiq /etc/init.d/sidekiq"
        sudo "chmod +x /etc/init.d/sidekiq"
        sudo "update-rc.d sidekiq defaults"
      end
    end

    %w[start stop restart].each do |command|
      desc "#{command} sidekiq"
      task command do
        on roles(:sidekiq) do
          execute "/etc/init.d/sidekiq #{command}"
        end
      end
    end 
  end 
  namespace :supervisor do
    task :setup do
      on roles(:sidekiq) do
        template "sidekiq_supervisor.erb", "/tmp/sidekiq"
        sudo "mv /tmp/sidekiq /etc/supervisor/conf.d/sidekiq.conf"
        sudo "supervisorctl reread"
        sudo "supervisorctl update" # it will auto start the application
      end
    end

    %w[start stop restart].each do |command|
      desc "#{command} sidekiq"
      task command do
        on roles(:sidekiq) do
          execute "supervisorctl #{command} sidekiq"
        end
      end
    end
    task :unload do
      desc "tell sidekiq stop receive new jobs, called at the beginning"
      on roles(:sidekiq) do
        execute "supervisorctl signal TSTP sidekiq"
      end
    end
    task :rolling_restart do
      desc "used for rolling restart, only available on enterprise version"
      on roles(:sidekiq) do
        execute "supervisorctl signal USR2 sidekiq"
      end
    end

    %w[start_group stop_group restart_group].each do |command|
      desc "#{command} sidekiq"
      task command do
        on roles(:sidekiq) do
          execute "supervisorctl #{command.split('_')[0]} sidekiq:*"
        end
      end
    end
    task :unload_group do
      desc "tell sidekiq stop receive new jobs, called at the beginning"
      on roles(:sidekiq) do
        execute "supervisorctl signal TSTP sidekiq:*"
      end
    end
    task :rolling_restart_group do
      desc "used for rolling restart, only available on enterprise version"
      on roles(:sidekiq) do
        execute "supervisorctl signal USR2 sidekiq:*"
      end
    end
  end
end
