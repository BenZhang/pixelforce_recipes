if Capistrano::Configuration.instance(false)

  Capistrano::Configuration.instance(true).load do |instance|

    namespace :puma do

      desc "Setup puma configuration for this application"
      task :setup, roles: :web do
        template "puma_init.erb", "/tmp/puma"
        run "#{sudo} mv /tmp/puma /etc/init.d/#{application}"
        run "#{sudo} chmod +x /etc/init.d/#{application}"
        run "#{sudo} update-rc.d #{application} defaults"
        template "nginx_puma_config.erb", "/tmp/nginx_puma_config"
        run "#{sudo} mv /tmp/nginx_puma_config /etc/nginx/sites-enabled/#{application}"
        template "logrotate.erb"
      end
      # after "deploy:setup", "nginx:setup"
      
      %w[start stop restart].each do |command|
        desc "#{command} puma"
        task command, roles: :web do
          run "/etc/init.d/#{application} #{command}"
        end
      end
    end
  end
end