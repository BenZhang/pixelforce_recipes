require "pixelforce_recipes/version"
require "capistrano"

require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/base")
require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/unicorn")
require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/sidekiq")
require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/puma")
require File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/logrotate")