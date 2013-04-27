class AuthorizedRailsScaffolds::RailsScaffoldControllerHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @modular_class_name = options[:class_name] || options[:local_class_name]
  end

  # Class name with parent modules included (i.e. Example::FooBar)
  # Name of class assumed by default generators, used as a base for determining modules and class
  def modular_class_name
    @modular_class_name
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