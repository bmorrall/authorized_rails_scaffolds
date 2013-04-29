class AuthorizedRailsScaffolds::RSpecScaffoldHelper < AuthorizedRailsScaffolds::Helper
  include TestVarMacros

  def initialize(options = {})
    super options

    @modular_class_name = options[:class_name] || options[:local_class_name]
    @attributes = options[:attributes]
  end

  # Class name with parent modules included (i.e. Example::FooBar)
  # Name of class assumed by default generators, used as a base for determining modules and class
  def modular_class_name
    @modular_class_name
  end

  def references_show_route(attribute_name, variable = nil)
    variable ||= "#{resource_test_var}.#{attribute_name}"
    super attribute_name, variable
  end

end
