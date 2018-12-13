namespace :sidekiq do
  desc "Install sidekiq"

  desc "Setup sidekiq configuration for this application"
  task :setup do
    on roles(:sidekiq) do
      template "sidekiq_init.erb", "/tmp/sidekiq"
      sudo "mv /tmp/sidekiq /etc/init.d/sidekiq"
      sudo "chmod +x /etc/init.d/sidekiq"
      sudo "update-rc.d sidekiq defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} sidekiq"
    task command do
      on roles(:resque) do
        execute "/etc/init.d/sidekiq #{command}"
      end
    end
  end
end
