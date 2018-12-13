namespace :puma do

  desc "Setup puma configuration for this application"
  task :setup do
    on roles(:web) do
      template "puma_init.erb", "/tmp/puma"
      sudo "mv /tmp/puma /etc/init.d/#{application}"
      sudo "chmod +x /etc/init.d/#{application}"
      sudo "update-rc.d #{application} defaults"
      template "nginx_puma_config.erb", "/tmp/nginx_puma_config"
      sudo "mv /tmp/nginx_puma_config /etc/nginx/sites-enabled/#{application}"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} puma"
    task command do
      on roles(:web) do
        execute "/etc/init.d/#{application} #{command}"
      end
    end
  end
end
