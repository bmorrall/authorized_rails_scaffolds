class AuthorizedRailsScaffolds::InstallMacrosGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option :authentication, :type => 'string', :default => 'devise', :desc => "Authentication Provider (Devise)"
  class_option :authorization, :type => 'string', :default => 'can_can', :desc => "Authorization Provider (CanCan)"

  def create_controller_macros
    parts = []
    parts << options[:authentication].underscore unless options[:authentication].nil?
    parts << options[:authorization].underscore unless options[:authorization].nil?
    template_file = parts.any? ? parts.join('_') : nil
    
    copy_file [template_file, 'controller_macros.rb'].join('/'), "spec/support/#{template_file}_controller_macros.rb"
    readme [template_file, 'USAGE'].join('/')
  end

end
