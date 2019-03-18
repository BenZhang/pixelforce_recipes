if Capistrano::Configuration.instance(false)
  Capistrano::Configuration.instance(true).load do |instance|
    namespace :resque_scheduler do
      desc "Install resque scheduler"

      desc "Setup resque scheduler configuration for this application"
      task :setup, roles: :resque do
        template "resque_scheduler_init.erb", "/tmp/resque_scheduler"
        run "#{sudo} mv /tmp/resque_scheduler /etc/init.d/resque_scheduler"
        run "#{sudo} chmod +x /etc/init.d/resque_scheduler"
        run "#{sudo} update-rc.d resque_scheduler defaults"
      end

      %w[start stop restart].each do |command|
        desc "#{command} resque scheduler"
        task command do
          run "/etc/init.d/resque_scheduler #{command}"
        end
      end
    end
  end
end