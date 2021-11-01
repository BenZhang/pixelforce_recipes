namespace :puma do
  desc 'Setup puma configuration for this application'
  task :config do
    on roles(:web) do
      template 'puma.rb.erb', '/tmp/puma_conf'
      sudo "mv /tmp/puma_conf #{shared_path}/config/puma.rb"
      execute "mkdir -p #{shared_path}/pids"
    end
  end

  namespace :systemd do
    task :setup do
      on roles(:web) do
        template 'puma_systemd.erb', '/tmp/puma.service'
        sudo 'mv /tmp/puma.service /etc/systemd/system/puma.service'
        sudo 'systemctl daemon-reload'
        sudo 'systemctl enable puma.service'
        sudo 'systemctl start puma.service'
      end
    end

    task :restart do
      on roles(:web) do
        sudo 'systemctl reload puma'
      end
    end
  end

  namespace :supervisor do
    task :uninstall do
      on roles(:web) do
        sudo "rm /etc/supervisor/conf.d/#{fetch(:application)}.conf"
        sudo "supervisorctl reread"
        sudo "supervisorctl update"
      end
    end
  end
end
