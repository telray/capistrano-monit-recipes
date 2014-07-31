require 'erb'

module Capistrano
  module Monit
    module HelperMethods

      def monit_config(name, destination = nil)
        destination ||= "/etc/monit/conf.d/#{name}.conf"
        template name, "/tmp/#{name}"

        execute :sudo, :mv, "/tmp/#{name} #{destination}"
        execute :sudo, :chown, "root #{destination}"
        execute :sudo, :chmod, "600 #{destination}"
      end

      def template(template_name, to)
        config_file = "#{fetch(:monit_templates_path)}/#{template_name}"
        # If there's no customized file in your rails app template directory,
        # proceed with the default.
        unless File.exists?(config_file)
          default_config_path = "../../generators/capistrano/monit/templates/#{template_name}"
          config_file = File.join(File.dirname(__FILE__), default_config_path)
        end
        template_file = ERB.new(File.read(config_file)).result(binding)
        upload! StringIO.new(template_file), to

        execute :sudo, :chmod, "644 #{to}"
      end
      
    end
  end
end
