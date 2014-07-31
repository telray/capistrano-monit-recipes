require 'capistrano/monit/helper_methods'
include Capistrano::Monit::HelperMethods

namespace :load do
  task :defaults do
    
    set :monit_configure_nginx, false
    set :monit_configure_postgresql, false
    set :monit_configure_unicorn, false
    set :monit_templates_path, 'config/deploy/templates'
    set :monitrc_path, '/etc/monit/monitrc'

    # UNICORN TEMPLATE specific settings
    set :monit_unicorn_process_name, "unicorn_#{fetch(:application)}_#{fetch(:stage)}"
    set :monit_unicorn_pid, shared_path.join("tmp/pids/unicorn.pid")
    set :monit_unicorn_service_name, "unicorn_#{fetch(:application)}_#{fetch(:stage)}"
    set :monit_unicorn_workers_number, 2
    set :monit_unicorn_worker_process_name, 'application_stage_unicorn_worker_'
    set :monit_alert_email, nil

    # NGINX TEMPLATE specific settings
    set :monit_nginx_pid, '/var/run/nginx.pid'

    # POSTGRESQL TEMPLATE specific settings
    set :monit_postgresql_pid, '/var/run/postgresql/9.3-main.pid'

    # MONIT TEMPLATE specific settings
    set :monit_gmail_username, nil
    set :monit_gmail_password, nil
    set :monit_alert_email, nil
    set :monit_password, nil

  end
end

namespace :monit do

  desc 'Setup all Monit configuration'
  task :setup do
    monit_config 'monitrc', fetch(:monitrc_path)
    monit_config 'monit_nginx'      if fetch(:monit_configure_nginx)?
    monit_config 'monit_postgresql' if fetch(:monit_configure_postgresql)?
    monit_config 'monit_unicorn'    if fetch(:monit_configure_unicorn)?
    syntax
    reload
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      execute :sudo, "service monit #{command}"
    end
  end

end

desc 'Server setup tasks'
task :setup do
  invoke 'monit:setup'
end
