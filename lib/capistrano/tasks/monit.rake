require 'capistrano/monit/helper_methods'
include Capistrano::Monit::HelperMethods

namespace :load do
  task :defaults do

    set :monit_configure_self, false
    set :monit_configure_nginx, false
    set :monit_configure_postgresql, false
    set :monit_configure_unicorn, false
    set :monit_templates_path, 'config/deploy/templates'
    set :monitrc_path, '/etc/monit/monitrc'    

    # UNICORN TEMPLATE specific settings
    set :monit_unicorn_process_name, -> { "unicorn_#{fetch(:application)}_#{fetch(:stage)}" }
    set :monit_unicorn_pid, shared_path.join("tmp/pids/unicorn.pid")
    set :monit_unicorn_service_name, -> { "unicorn_#{fetch(:application)}_#{fetch(:stage)}" }
    set :monit_unicorn_workers_number, 2
    set :monit_unicorn_worker_process_name, -> { "#{fetch(:application)}_#{fetch(:stage)}_unicorn_worker_" }
    set :monit_alert_email, nil

    # NGINX TEMPLATE specific settings
    set :monit_nginx_pid, '/var/run/nginx.pid'

    # POSTGRESQL TEMPLATE specific settings
    set :monit_postgresql_pid, '/var/run/postgresql/9.4-main.pid'

    # MONIT TEMPLATE specific settings
    set :monit_gmail_username, nil
    set :monit_gmail_password, nil
    set :monit_alert_email, nil
    set :monit_password, nil
    set :monit_port, '2812'

  end
end

namespace :monit do

  desc 'Generate config file for Monit'
  task :generate_config do
    on roles :app do
      upload! monit_template('monitrc'), tmp_path('monitrc')
      final_path('monitrc', fetch(:monitrc_path))      
    end
  end

  desc 'Generate config file for Nginx process'
  task :generate_nginx_config do
    on roles :app do
      upload! monit_template('monit_nginx'), tmp_path('monit_nginx')
      final_path('monit_nginx')
    end
  end

  desc 'Generate config file for Postgresql process'
  task :generate_postgresql_config do
    on roles :app do
      upload! monit_template('monit_postgresql'), tmp_path('monit_postgresql')
      final_path('monit_postgresql')
    end
  end

  desc 'Generate config file for Unicorn process'
  task :generate_unicorn_config do
    on roles :app do
      upload! monit_template('monit_unicorn'), tmp_path('monit_unicorn')
      final_path('monit_unicorn')
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles :app do
        execute :sudo, "service monit #{command}"
      end
    end
  end

  after 'deploy:started', 'monit:reload'

end

desc 'Server setup tasks'
task :setup do
  invoke 'monit:generate_config' if fetch(:monit_configure_self)
  invoke 'monit:generate_nginx_config' if fetch(:monit_configure_nginx)
  invoke 'monit:generate_postgresql_config' if fetch(:monit_configure_postgresql)
  invoke 'monit:generate_unicorn_config' if fetch(:monit_configure_unicorn)
  invoke 'monit:syntax'
  invoke 'monit:reload'
end
