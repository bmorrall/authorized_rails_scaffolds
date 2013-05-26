class AuthorizedRailsScaffolds::RSpecScaffoldHelper < AuthorizedRailsScaffolds::Helper
  include AuthorizedRailsScaffolds::Macros::TestVarMacros

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

  def parent_variables(use_shallow_route=false)
    @parent_variables ||= parent_model_names.collect{ |parent_table| references_test_name(parent_table) }
    use_shallow_route ? @parent_variables[0..-2] : @parent_variables
  end

  def references_show_route(attribute_name, variable = nil)
    variable ||= "#{resource_test_name}.#{attribute_name}"
    super attribute_name, variable
  end

  def start_nesting_block
    if parent_model_names.any?
      "context \"within #{parent_model_names.join('/')} nesting\" do"
    else
      'context do # Within default nesting'
    end
  end

  def start_shallow_nesting_block
    if shallow_routes?
      'context do # Within shallow nesting'
    else
      start_nesting_block
    end
  end

  def end_nesting_block
    'end'
  end

  def describe_nesting_comment
    if parent_model_names.any?
      "within #{parent_model_names.join('/')} nesting"
    else
      "Within default nesting"
    end
  end

end
