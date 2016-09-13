if Capistrano::Configuration.instance(false)

  Capistrano::Configuration.instance(true).load do |instance|

    namespace :delayed_job do
      desc "Setup delayed job"

      desc "Setup delayed configuration for this application"
      task :setup, roles: :web do
        template "delayed_job_init.erb", "/tmp/delayed"
        run "#{sudo} mv /tmp/delayed /etc/init.d/#{application}_delayed"
        run "#{sudo} chmod +x /etc/init.d/#{application}_delayed"
        run "#{sudo} update-rc.d #{application}_delayed defaults"
      end
      
      desc "Setup delayed job monit configuration for this application"
      task :setup_monit, roles: :web do
        run "#{sudo} apt-get -y install monit"
        template "monit_delayed_config.erb", "/tmp/delayed_monit"
        run "#{sudo} mv /tmp/delayed_monit /etc/monit/conf.d/#{application}_delayed"
        run "#{sudo} monit reload"
        run "#{sudo} monit start all"
      end
      
      %w[start stop reindex].each do |command|
        desc "#{command} delayed"
        task command, roles: :web do
          run "/etc/init.d/#{application}_delayed #{command}"
        end
      end
    end
    
  end

end