class AuthorizedRailsScaffolds::RSpecScaffoldRoutingHelper < AuthorizedRailsScaffolds::RSpecScaffoldHelper
  include AuthorizedRailsScaffolds::Macros::ControllerMacros
  include AuthorizedRailsScaffolds::Macros::RouteExampleMacros

  def initialize(options = {})
    super options

    # Modularized class name generated by spec generator
    @controller_class_name = options[:controller_class_name]
  end

end