namespace :unicorn do
  desc "Install unicorn"

  desc "Setup unicorn configuration for this application"
  task :setup do
    on roles(:web) do
      template "unicorn_init.erb", "/tmp/unicorn"
      sudo "mv /tmp/unicorn /etc/init.d/#{application}"
      sudo "chmod +x /etc/init.d/#{application}"
      sudo "update-rc.d #{application} defaults"
      template "nginx_config.erb", "/tmp/nginx_config"
      sudo "mv /tmp/nginx_config /etc/nginx/sites-enabled/#{application}"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:web) do
        execute "/etc/init.d/#{application} #{command}"
      end
    end
  end
end
