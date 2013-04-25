class AuthorizedRailsScaffolds::RSpecScaffoldHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @controller_class_name = options[:class_name] || options[:local_class_name]
    @attributes = options[:attributes]
  end

  def controller_class_name
    @controller_class_name
  end

end
