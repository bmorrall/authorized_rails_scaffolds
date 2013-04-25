class AuthorizedRailsScaffolds::RSpecScaffoldHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    parent_models = AuthorizedRailsScaffolds.config.parent_models

    @controller_class_name = options[:class_name] || options[:local_class_name]

    class_name_parts = @controller_class_name.split("::")

    @attributes = options[:attributes]
  end

  def controller_class_name
    @controller_class_name
  end

end