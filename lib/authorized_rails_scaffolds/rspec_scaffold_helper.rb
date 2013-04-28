class AuthorizedRailsScaffolds::RSpecScaffoldHelper < AuthorizedRailsScaffolds::Helper

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

  # Symbol used to assign test resources (i.e. :foo_bar)
  def resource_test_sym(var_number = nil)
    ":#{resource_test_property(var_number)}"
  end

  # Variable name stub resource is assigned to (i.e. @foo_bar)
  def resource_test_var(var_number = nil)
    "@#{resource_test_property(var_number)}"
  end

  # Generator for properties used for testing
  def resource_test_property(var_number = nil)
    resource_property = var_name
    resource_property = "#{resource_property}_#{var_number}" unless var_number.nil?
    resource_property
  end

end
