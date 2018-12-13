namespace :resque do
  desc "Install resque"

  desc "Setup resque configuration for this application"
  task :setup do
    on roles(:resque) do
      template "resque_init.erb", "/tmp/resque"
      sudo "mv /tmp/resque /etc/init.d/resque"
      sudo "chmod +x /etc/init.d/resque"
      sudo "update-rc.d resque defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} resque"
    task command do
      on roles(:resque) do
        execute "/etc/init.d/resque #{command}"
      end
    end
  end
end
