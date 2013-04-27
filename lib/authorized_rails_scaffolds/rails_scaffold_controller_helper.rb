class AuthorizedRailsScaffolds::RailsScaffoldControllerHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @controller_class_name = options[:class_name] || options[:local_class_name]
  end

  def controller_class_name
    @controller_class_name
  end

  # The namespaced class the Controller inherits from (i.e. Example::ApplicationController)
  def application_controller_class
    @application_controller_class = 'ApplicationController'
    if parent_modules.any?
      @application_controller_class = "#{parent_modules.join('::')}::#{@application_controller_class}"
    end
    @application_controller_class
  end

end