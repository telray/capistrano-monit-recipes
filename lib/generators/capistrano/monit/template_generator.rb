module Capistrano
  module Monit
    module Generators
      class TemplateGenerator < Rails::Generators::Base

        desc "Create local monitrc.erb, and erb files for monitored processes for customization"
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, type: :string,
          default: "config/deploy/templates",
          banner: "path to templates"

        def copy_template
          copy_file "monitrc.erb", "#{templates_path}/monitrc.erb"
          copy_file "monit_nginx.erb", "#{templates_path}/monit_nginx.erb"
          copy_file "monit_postgresql.erb", "#{templates_path}/monit_postgresql.erb"
          copy_file "monit_unicorn.erb", "#{templates_path}/monit_unicorn.erb"
        end

      end
    end
  end
end
