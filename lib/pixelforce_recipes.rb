require "pixelforce_recipes/version"
require "capistrano"

if defined?(Capistrano::VERSION)
  if Capistrano::VERSION.to_s.split('.').first.to_i >= 3
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/base")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/sidekiq")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/resque")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/resque_scheduler")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/logrotate")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/unicorn")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/puma")
  else
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/base")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/unicorn")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/sidekiq")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/resque")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/puma")
    require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/logrotate")
  end
end
