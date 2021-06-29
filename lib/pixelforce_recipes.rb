require "pixelforce_recipes/version"
require "capistrano"

if defined?(Capistrano::VERSION)
  if Capistrano::VERSION.to_s.split('.').first.to_i >= 3
    Dir[File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/capistrano_3_recipes/*.rb")].each {|file| require file }    
  else
    Dir[File.expand_path("#{File.dirname(__FILE__)}/pixelforce_recipes/legacy_recipes/*.rb")].each {|file| require file }    
  end
end
