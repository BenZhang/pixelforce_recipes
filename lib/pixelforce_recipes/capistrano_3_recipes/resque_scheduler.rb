namespace :resque_scheduler do
  desc "Install resque scheduler"

  desc "Setup resque scheduler configuration for this application"
  task :setup do
    on roles(:resque) do
      template "resque_scheduler_init.erb", "/tmp/resque_scheduler"
      sudo "mv /tmp/resque_scheduler /etc/init.d/resque_scheduler"
      sudo "chmod +x /etc/init.d/resque_scheduler"
      sudo "update-rc.d resque_scheduler defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} resque_scheduler"
    task command do
      on roles(:resque) do
        execute "/etc/init.d/resque_scheduler #{command}"
      end
    end
  end
end
