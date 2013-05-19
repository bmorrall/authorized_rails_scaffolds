#
# requires modular_class_name to be defined
#
module ResourceMacros

  ### Base Resource ###

  # Class name of the resource being tested (i.e. 'FooBar')
  def resource_class
    # @local_class_name
    @resource_class ||= (modular_class_name.nil? ? nil : modular_class_name.split('::')[-1]) || var_name.classify
  end

  # Table name of the Resource being tested (i.e. foo_bar)
  def resource_name
    @resource_name ||= (var_name || resource_class.underscore)
  end

  # Symbol used to represent resource (i.e. :foo_bar)
  def resource_symbol
    ":#{resource_name}"
  end

  # Variable resource is assigned to in a singular context (i.e. @foo_bar)
  def resource_var
    @resource_var_name ||= "@#{resource_name}"
  end

  # Name for plural of a resource
  def resource_array_name
    @resource_array_name ||= (plural_var_name || resource_name.pluralize)
  end

  # Variable resource is assigned to in a plural context (i.e. @foo_bars)
  def resource_array_var
    @resource_var_name ||= "@#{resource_array_name}"
  end

  def resource_array_sym
    @resource_array_sym ||= ":#{resource_array_name}"
  end

  # Directory of the current resource: i.e. awesome/foo_bars
  def resource_directory
    @resource_directory = ((parent_module_groups || []) + [resource_array_name]).join("/")
  end

end