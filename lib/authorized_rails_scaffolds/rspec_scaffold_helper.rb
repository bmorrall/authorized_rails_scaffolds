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

  # Variable name stub resource is assigned to (i.e. @foo_bar)
  def resource_test_var
    "@#{var_name}"
  end

end
