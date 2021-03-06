class AuthorizedRailsScaffolds::RailsHelperHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @modular_class_name = options[:class_name] || options[:local_class_name]
  end

  # Class name with parent modules included (i.e. Example::FooBar)
  # Name of class assumed by default generators, used as a base for determining modules and class
  def modular_class_name
    @modular_class_name.singularize
  end

  # returns values that should be parsed by a form in order for post and put actions to work
  def scoped_values_for_form(variable, use_shallow_route=false)
    variable ||= resource_var

    form_argument_values = []

    # Add the modules
    parent_module_groups.each do |parent_module|
      form_argument_values << ":#{parent_module}"
    end

    # Add the models
    parent_models = use_shallow_route ? parent_model_names[0..-2] : parent_model_names
    parent_models.each do |parent_model|
      form_argument_values << parent_variable(parent_model)
    end

    form_argument_values << variable

    if form_argument_values.count == 1
      return variable
    else
      "[#{form_argument_values.join(', ')}]"
    end
  end

end