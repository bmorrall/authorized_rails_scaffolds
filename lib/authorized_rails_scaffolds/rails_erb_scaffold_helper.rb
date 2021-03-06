class AuthorizedRailsScaffolds::RailsErbScaffoldHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @modular_class_name = options[:class_name] || options[:local_class_name]
  end

  # Class name with parent modules included (i.e. Example::FooBar)
  # Name of class assumed by default generators, used as a base for determining modules and class
  def modular_class_name
    @modular_class_name
  end

end