namespace :puma do

  desc "Setup puma configuration for this application"
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

  %w[start stop restart].each do |command|
    desc "#{command} puma"
    task command do
      on roles(:web) do
        execute "supervisorctl #{command} #{fetch(:application)}"
      end
    end
  end
end
