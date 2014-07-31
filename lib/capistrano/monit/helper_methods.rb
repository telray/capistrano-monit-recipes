require 'erb'

module Capistrano
  module Monit
    module HelperMethods

      def monit_template(template_name)
        config_file = "#{fetch(:monit_templates_path)}/#{template_name}.erb"
        unless File.exists?(config_file)
          default_config_path = "../../generators/capistrano/monit/templates/#{template_name}.erb"
          config_file = File.join(File.dirname(__FILE__), default_config_path)
        end
        StringIO.new ERB.new(File.read(config_file)).result(binding)
      end

      def tmp_path(process_name)
        "/tmp/#{process_name}"
      end

      def final_path(name, path = nil)
        path ||= "/etc/monit/conf.d/#{name}.conf"

        execute :sudo, :chmod, "644 #{tmp_path(name)}"
        execute :sudo, :mv, "#{tmp_path(name)} #{path}"
        execute :sudo, :chown, "root #{path}"
        execute :sudo, :chmod, "600 #{path}"
      end

    end
  end
end
