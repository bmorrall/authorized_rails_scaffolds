class AuthorizedRailsScaffolds::InstallTemplatesGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_rails_templates
    # Controller Templates
    copy_rails_scaffold_controller 'controller.rb'

    # View Templates (erb)
    copy_erb_scaffold_template '_form.html.erb'
    copy_erb_scaffold_template 'edit.html.erb'
    copy_erb_scaffold_template 'index.html.erb'
    copy_erb_scaffold_template 'new.html.erb'
    copy_erb_scaffold_template 'show.html.erb'
  end

  def create_spec_templates
    # Controller Spec Templates
    copy_rspec_scaffold_template 'controller_spec.rb'

    # Model Spec Templates
    copy_rspec_model_template 'model_spec.rb'

    # Request Spec Templates
    copy_rspec_integration_template 'request_spec.rb'

    # Routing Spec Templates
    copy_rspec_scaffold_template 'routing_spec.rb'

    # View Spec Templates
    copy_rspec_scaffold_template 'edit_spec.rb'
    copy_rspec_scaffold_template 'index_spec.rb'
    copy_rspec_scaffold_template 'new_spec.rb'
    copy_rspec_scaffold_template 'show_spec.rb'
  end

  protected

  def copy_erb_scaffold_template(template_name)
    copy_file "scaffold/#{template_name}", "lib/templates/erb/scaffold/#{template_name}"
  end

  def copy_rails_scaffold_controller(template_name)
    copy_file "scaffold/#{template_name}", "lib/templates/rails/scaffold_controller/#{template_name}"
  end

  def copy_rspec_integration_template(template_name)
    copy_file "spec/#{template_name}", "lib/templates/rspec/integration/#{template_name}"
  end

  def copy_rspec_model_template(template_name)
    copy_file "spec/#{template_name}", "lib/templates/rspec/model/#{template_name}"
  end

  def copy_rspec_scaffold_template(template_name)
    copy_file "spec/#{template_name}", "lib/templates/rspec/scaffold/#{template_name}"
  end

end
