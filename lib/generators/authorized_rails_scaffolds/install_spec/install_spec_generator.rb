class AuthorizedRailsScaffolds::InstallSpecGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option :authentication, :type => 'string', :default => 'devise', :desc => "Authentication Provider (Devise)"
  class_option :authorization, :type => 'string', :default => 'can_can', :desc => "Authorization Provider (CanCan)"
  

  def create_rspec_templates
    copy_rspec_template 'controller_spec.rb'
    copy_rspec_template 'edit_spec.rb'
    copy_rspec_template 'index_spec.rb'
    copy_rspec_template 'new_spec.rb'
    copy_rspec_template 'show_spec.rb'
  end

  def create_controller_macros
    parts = []
    parts << options[:authentication].underscore unless options[:authentication].nil?
    parts << options[:authorization].underscore unless options[:authorization].nil?
    template_file = parts.any? ? parts.join('_') : nil
    
    copy_file [template_file, 'controller_macros.rb'].join('/'), "spec/support/#{template_file}_controller_macros.rb"
    readme [template_file, 'USAGE'].join('/')
  end

  protected

  def copy_rspec_template(template_name)
    copy_file template_name, "lib/templates/rspec/scaffold/#{template_name}"
  end

end
