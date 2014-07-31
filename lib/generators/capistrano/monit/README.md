To create local `monitrc.erb` template and Nginx, Postgresql and Unicorn 
processes in a default path "config/deploy/templates" type in your shell:

    bundle exec rails generate capistrano:monit:template

This is how you override the default path:

    bundle exec rails generate capistrano:monit:template "config/templates"

If you override templates path, don't forget to set "monit_templates_path"
variable in your deploy.rb
