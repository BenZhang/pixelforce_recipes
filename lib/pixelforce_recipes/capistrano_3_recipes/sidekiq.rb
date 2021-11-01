namespace :sidekiq do
  desc 'Install sidekiq'

  namespace :systemd do
    task :setup do
      on roles(:web) do
        template 'sidekiq_systemd.erb', '/tmp/sidekiq.service'
        sudo 'mv /tmp/sidekiq.service /etc/systemd/system/sidekiq.service'
        sudo 'systemctl daemon-reload'
        sudo 'systemctl enable sidekiq'
        sudo 'systemctl start sidekiq'
      end
    end

    task :unload do
      on roles(:web) do
        sudo 'systemctl kill -s TSTP sidekiq'
      end
    end

    task :restart do
      on roles(:web) do
        sudo 'systemctl restart sidekiq'
      end
    end
  end

  namespace :supervisor do
    task :uninstall do
      on roles(:sidekiq) do
        sudo 'rm/etc/supervisor/conf.d/sidekiq.conf'
        sudo 'supervisorctl reread'
        sudo 'supervisorctl update'
      end
    end
  end
end
