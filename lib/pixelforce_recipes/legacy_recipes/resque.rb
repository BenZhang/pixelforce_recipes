if Capistrano::Configuration.instance(false)
  Capistrano::Configuration.instance(true).load do |instance|
    namespace :resque do
      desc "Install resque"

      desc "Setup resque configuration for this application"
      task :setup, roles: :resque do
        template "resque_init.erb", "/tmp/resque"
        run "#{sudo} mv /tmp/resque /etc/init.d/resque"
        run "#{sudo} chmod +x /etc/init.d/resque"
        run "#{sudo} update-rc.d resque defaults"
      end

      %w[start stop restart].each do |command|
        desc "#{command} resque"
        task command do
          run "/etc/init.d/resque #{command}"
        end
      end
    end
  end
end