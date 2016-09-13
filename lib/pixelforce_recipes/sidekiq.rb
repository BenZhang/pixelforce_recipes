if Capistrano::Configuration.instance(false)
  Capistrano::Configuration.instance(true).load do |instance|
    namespace :sidekiq do
      desc "Install sidekiq"

      desc "Setup sidekiq configuration for this application"
      task :setup, roles: :sidekiq do
        template "sidekiq_init.erb", "/tmp/sidekiq"
        run "#{sudo} mv /tmp/sidekiq /etc/init.d/sidekiq"
        run "#{sudo} chmod +x /etc/init.d/sidekiq"
        run "#{sudo} update-rc.d sidekiq defaults"
      end
      # after "deploy:setup", "nginx:setup"
      
      %w[start stop restart].each do |command|
        desc "#{command} sidekiq"
        task command do
          run "/etc/init.d/sidekiq #{command}"
        end
      end
    end
  end
end