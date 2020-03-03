namespace :unicorn do
  desc "Install unicorn"
  namespace :sysvinit do
    task :setup do
      on roles(:web) do
        template "unicorn_init.erb", "/tmp/unicorn"
        sudo "mv /tmp/unicorn /etc/init.d/#{fetch(:application)}"
        sudo "chmod +x /etc/init.d/#{fetch(:application)}"
        sudo "update-rc.d #{fetch(:application)} defaults"
        template "nginx_config.erb", "/tmp/nginx_config"
        sudo "mv /tmp/nginx_config /etc/nginx/sites-enabled/#{fetch(:application)}"
      end
    end

    %w[start stop restart reload].each do |command|
      desc "#{command} unicorn"
      task command do
        on roles(:web) do
          execute "/etc/init.d/#{fetch(:application)} #{command}"
        end
      end
    end
  end
  namespace :supervisor do
    desc "Setup unicorn configuration for this application"
    task :setup do
      on roles(:web) do
        template "unicorn_supervisor.erb", "/tmp/unicorn"
        sudo "mv /tmp/unicorn /etc/supervisor/conf.d/#{fetch(:application)}"
        sudo "supervisorctl reread"
        sudo "supervisorctl update" # it will auto start the application
        template "nginx_config.erb", "/tmp/nginx_config"
        sudo "mv /tmp/nginx_config /etc/nginx/sites-enabled/#{fetch(:application)}"
      end
    end

    task :start do
      on roles(:web) do
        execute "supervisorctl start #{fetch(:application)}"
      end
    end
    task :stop do
      on roles(:web) do
        execute "supervisorctl signal QUIT #{fetch(:application)}"
      end
    end
    task :restart do
      on roles(:web) do
        execute "supervisorctl signal USR2 #{fetch(:application)}"
      end
    end
    task :reload do
      on roles(:web) do
        execute "supervisorctl signal HUP #{fetch(:application)}"
      end
    end
  end
end
