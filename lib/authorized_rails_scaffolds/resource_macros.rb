#
# requires modular_class_name to be defined
#
module ResourceMacros

  ### Base Resource ###

  # Class name of the resource being tested (i.e. 'FooBar')
  def resource_class
    @resource_class ||= modular_class_name.split('::')[-1]
  end

  # Table name of the Resource being tested (i.e. foo_bar)
  def resource_table_name
    @resource_table_name ||= resource_class.underscore
  end

  # Name for plural of a resource
  def resource_plural_name
    @resource_plural_name ||= plural_var_name || (var_name || resource_table_name).pluralize
  end

  # Variable resource is assigned to in a singular context (i.e. @foo_bar)
  def resource_var
    @resource_var_name ||= "@#{var_name || resource_table_name}"
  end

  # Variable resource is assigned to in a plural context (i.e. @foo_bars)
  def resources_var
    @resource_var_name ||= "@#{resource_plural_name}"
  end

  # Directory of the current resource: i.e. awesome/foo_bars
  def resource_directory
    @resource_directory = [parent_module_groups + [resource_table_name.pluralize]].join("/")
  end

  ### Parent Models ###

  # An array of parent model classes (i.e. ['User', 'Category])
  def parent_models
    @parent_models ||= AuthorizedRailsScaffolds.config.parent_models
  end

  # Table names of parent models (i.e. ['user', 'category'])
  def parent_model_tables
    @parent_model_tables ||= parent_models.map { |model| model.underscore }
  end

  ### Parent Modules ###

  # The parent modules of a controller (i.e. ['Api', 'V1'])
  def parent_modules
    @parent_modules ||= modular_class_name.split('::')[0..-2]
  end

  # Array of symbols used for links to parents (i.e. ['api', 'v1'])
  def parent_module_groups
    @parent_module_groups ||= parent_modules.map { |parent_module| parent_module.underscore }
  end

end