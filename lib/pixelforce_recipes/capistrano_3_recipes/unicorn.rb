namespace :unicorn do
  desc "Install unicorn"

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

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:web) do
        execute "supervisorctl #{command} #{fetch(:application)}"
      end
    end
  end
end
