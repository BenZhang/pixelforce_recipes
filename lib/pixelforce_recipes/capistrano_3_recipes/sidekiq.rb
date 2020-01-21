namespace :sidekiq do
  desc "Install sidekiq"

  desc "Setup sidekiq configuration for this application"
  task :setup do
    on roles(:sidekiq) do
      template "sidekiq_supervisor.erb", "/tmp/sidekiq"
      sudo "mv /tmp/sidekiq /etc/supervisor/conf.d/sidekiq"
      sudo "supervisorctl reread"
      sudo "supervisorctl update" # it will auto start the application
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} sidekiq"
    task command do
      on roles(:sidekiq) do
        execute "supervisorctl #{command} sidekiq"
      end
    end
  end
end
