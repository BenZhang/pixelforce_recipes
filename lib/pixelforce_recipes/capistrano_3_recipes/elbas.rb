namespace :elbas do
  desc 'Sync files before creating AMI'
  task :sync do
    on roles(:app) do
      execute "sync"
    end
  end

  before "elbas:deploy", "elbas:sync"
end
