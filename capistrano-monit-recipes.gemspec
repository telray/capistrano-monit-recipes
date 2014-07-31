# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'capistrano/monit/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-monit-recipes"
  #gem.version       = Capistrano::Monit::VERSION
  gem.version       = '0.0.0'
  gem.date          = '2014-07-31'
  gem.authors       = ["Louis Houette"]
  gem.email         = ["louishouette@gmail.com"]
  gem.description   = <<-EOF.gsub(/^\s+/, '')
    Capistrano tasks for Monit configuration and management for Rails
    apps. Manages `monitrc` template on the server, and Nginx, Postgresql and Unicorn processes.

    Works with Capistrano 3 (only).
  EOF
  gem.summary       = %q{Creates Monit configuration file on the server and templates for supervising Nginx, Postgresql and unicorn processes}
  gem.homepage      = "https://github.com/louishouette/capistrano-monit-recipes"

  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 3.0'

  gem.add_development_dependency "rake"
end
