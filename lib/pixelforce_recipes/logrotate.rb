if Capistrano::Configuration.instance(false)

  Capistrano::Configuration.instance(true).load do |instance|

    namespace :logrotate do

      desc "Setup logrotate configuration for this application"
      task :setup, roles: :app do
        template "logrotate.erb", "/tmp/logrotate"
        run "#{sudo} mv /tmp/logrotate /etc/logrotate.d/#{application}"
      end
    end
  end
end