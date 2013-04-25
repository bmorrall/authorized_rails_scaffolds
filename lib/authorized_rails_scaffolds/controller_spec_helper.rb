class AuthorizedRailsScaffolds::ControllerSpecHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    parent_models = AuthorizedRailsScaffolds.config.parent_models

    class_name_parts = (options[:class_name] || options[:local_class_name]).split("::")

    example_parent_values = {}
    parent_models.each_with_index do |parent_model, index|
      example_parent_values[parent_model] = index + 2
    end

    namespace_prefix_modules = class_name_parts[0..-2] # ['Example', 'V1']
    local_class_name = class_name_parts[-1]
    parent_model_and_value_parts = []
    parent_models.each do |parent_model|
      parent_model_and_value_parts << parent_model.pluralize
      parent_model_and_value_parts << example_parent_values[parent_model]
    end

    # Directory for the generated controller: i.e. awesome/foo_bars
    @controller_directory = [namespace_prefix_modules + [local_class_name]].join("/").underscore

    # Example index route: i.e. /awesome/users/2/foo_bars
    @example_controller_path = [namespace_prefix_modules + parent_model_and_value_parts + [local_class_name]].join("/").underscore

    @attributes = options[:attributes]
  end

  def create_factory_model
    extra_params = extra_model_params
    "FactoryGirl.create(:#{var_name}#{extra_params})"
  end

  def create_parent_model(model_name)
    extra_params = extra_model_params(model_name)
    "FactoryGirl.create(:#{model_name}#{extra_params})"
  end

  # Directory for the generated controller: i.e. awesome/foo_bars
  def controller_directory
    @controller_directory
  end

  # Example index route: i.e. /awesome/users/2/foo_bars
  def example_controller_path
    "/#{@example_controller_path}"
  end

  protected

  def extra_model_params(model_name = nil)
    argument_params = []
    AuthorizedRailsScaffolds.config.parent_models.each do |parent_model|
      attribute = parent_model.underscore
      break if model_name == attribute
      argument_params << ", :#{attribute} => @#{attribute}"
    end
    argument_params.join('')
  end

end