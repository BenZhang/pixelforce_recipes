namespace :sidekiq do
  desc 'Install sidekiq'

  namespace :systemd do
    task :setup do
      on roles(:app) do
        template 'sidekiq_systemd.erb', '/tmp/sidekiq.service'
        sudo 'mv /tmp/sidekiq.service /etc/systemd/system/sidekiq.service'
        sudo 'systemctl daemon-reload'
        sudo 'systemctl enable sidekiq'
        sudo 'systemctl start sidekiq'
      end
    end

    task :unload do
      on roles(:app) do
        sudo 'systemctl kill -s TSTP sidekiq'
      end
    end

    task :restart do
      on roles(:app) do
        sudo 'systemctl restart sidekiq'
      end
    end
  end

  namespace :supervisor do
    task :uninstall do
      on roles(:sidekiq) do
        sudo 'rm /etc/supervisor/conf.d/sidekiq.conf'
        sudo 'supervisorctl reread'
        sudo 'supervisorctl update'
      end
    end

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
