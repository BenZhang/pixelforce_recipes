namespace :puma do

  desc "Setup puma configuration for this application"
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

  %w[start stop restart].each do |command|
    desc "#{command} puma"
    task command do
      on roles(:web) do
        execute "/etc/init.d/#{fetch(:application)} #{command}"
      end
    end
  end
end
