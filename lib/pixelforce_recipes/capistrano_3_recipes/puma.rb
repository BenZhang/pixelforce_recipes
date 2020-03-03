namespace :puma do

  desc "Setup puma configuration for this application"
  task :config do
    on roles(:web) do
      template "puma.rb.erb", "/tmp/puma_conf"
      sudo "mv /tmp/puma_conf #{shared_path}/config"
    end
  end
  namespace :sysvinit do
    task :setup do
      on roles(:web) do
        template "puma_init.erb", "/tmp/puma"
        sudo "mv /tmp/puma /etc/init.d/#{fetch(:application)}"
        sudo "chmod +x /etc/init.d/#{fetch(:application)}"
        sudo "update-rc.d #{fetch(:application)} defaults"
        template "nginx_puma_config.erb", "/tmp/nginx_puma_config"
        sudo "mv /tmp/nginx_puma_config /etc/nginx/sites-enabled/#{fetch(:application)}"
      end
    end

    %w[start stop restart reload].each do |command|
      desc "#{command} puma"
      task command do
        on roles(:web) do
          execute "/etc/init.d/#{fetch(:application)} #{command}"
        end
      end
    end
  end
  namespace :supervisor do
    task :setup do
      on roles(:web) do
        template "puma_supervisor.erb", "/tmp/puma"
        sudo "mv /tmp/puma /etc/supervisor/conf.d/#{fetch(:application)}"
        sudo "supervisorctl reread"
        sudo "supervisorctl update" # it will auto start the application
        template "nginx_puma_config.erb", "/tmp/nginx_puma_config"
        sudo "mv /tmp/nginx_puma_config /etc/nginx/sites-enabled/#{fetch(:application)}"
      end
    end

    task :start do
      on roles(:web) do
        execute "supervisorctl start #{fetch(:application)}"
      end
    end
    task :stop do
      on roles(:web) do
        execute "supervisorctl signal INT #{fetch(:application)}"
      end
    end
    task :restart do
      on roles(:web) do
        execute "supervisorctl signal USR1 #{fetch(:application)}"
      end
    end
    task :reload do
      on roles(:web) do
        execute "supervisorctl signal USR2 #{fetch(:application)}"
      end
    end
  end
end
