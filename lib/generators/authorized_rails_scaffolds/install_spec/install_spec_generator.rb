class AuthorizedRailsScaffolds::InstallSpecGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_rspec_templates
    copy_rspec_template 'controller_spec.rb'
    copy_rspec_template 'edit_spec.rb'
    copy_rspec_template 'index_spec.rb'
    copy_rspec_template 'new_spec.rb'
    copy_rspec_template 'show_spec.rb'
  end

  protected

  def copy_rspec_template(template_name)
    copy_file template_name, "lib/templates/rspec/scaffold/#{template_name}"
  end

end
