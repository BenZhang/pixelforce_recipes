if Capistrano::Configuration.instance(false)

  Capistrano::Configuration.instance(true).load do |instance|

    def template(from, to)
      erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
      put ERB.new(erb).result(binding), to
    end

    def set_default(name, *args, &block)
      set(name, *args, &block) unless exists?(name)
    end

    namespace :deploy do
      desc "Install everything onto the server"
      task :install do
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install curl git-core python-software-properties build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion"
      end
    end
  
  end

end