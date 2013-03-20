class AuthorizedRailsScaffolds::InstallScaffoldGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_erb_templates
    copy_erb_template '_form.html.erb'
    copy_erb_template 'edit.html.erb'
    copy_erb_template 'index.html.erb'
    copy_erb_template 'new.html.erb'
    copy_erb_template 'show.html.erb'
  end

  def copy_rails_templates
    copy_rails_template 'controller.rb'
  end

  protected

  def copy_erb_template(template_name)
    copy_file template_name, "lib/templates/erb/scaffold/#{template_name}"
  end

  def copy_rails_template(template_name)
    copy_file template_name, "lib/templates/rails/scaffold_controller/#{template_name}"
  end

end
