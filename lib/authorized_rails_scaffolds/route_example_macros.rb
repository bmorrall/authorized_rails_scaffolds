module RouteExampleMacros

  # Example index route: i.e. /awesome/users/2/foo_bars
  def example_index_path
    unless @example_index_path
      example_index_path_parts = []

      parent_model_names.each do |parent_model|
        # users, 2
        parent_value = example_parent_values["#{parent_model}_id"]
        example_index_path_parts << parent_model.pluralize
        example_index_path_parts << parent_value
      end

      # Example index route: i.e. /awesome/users/2/foo_bars
      @example_index_path = [parent_module_groups + example_index_path_parts + [resource_array_name]].join("/")
    end
    "/#{@example_index_path}"
  end

  def example_show_path
    unless @example_show_path
      example_show_path_parts = []

      parent_names = shallow_routes? ? parent_model_names[0..-2] : parent_model_names
      parent_names.each do |parent_model|
        # users, 2
        parent_value = example_parent_values["#{parent_model}_id"]
        example_show_path_parts << parent_model.pluralize
        example_show_path_parts << parent_value
      end

      # Example index route: i.e. /awesome/users/2/foo_bars
      @example_show_path = [parent_module_groups + example_show_path_parts + [resource_array_name]].join("/")
    end
    "/#{@example_show_path}"
  end

  # Extra params for an example controller path: i.e. ', :user_id => 2'
  def example_index_path_extra_params
    @example_index_path_extra_params ||= example_parent_values.map{ |parent_model_id, parent_value| ", :#{parent_model_id} => \"#{parent_value}\"" }.join('')
  end

  def example_show_path_extra_params
    @example_show_path_extra_params ||= example_parent_values(shallow_routes?).map{ |parent_model_id, parent_value| ", :#{parent_model_id} => \"#{parent_value}\"" }.join('')
  end

  def example_route_extra_params(use_shallow_route=false)
    @example_route_extra_params ||= parent_model_names.collect{ |parent_table| ":#{parent_table}_id => #{references_test_name(parent_table)}.to_param" }
    use_shallow_route ? @example_route_extra_params[0..-2] : @example_route_extra_params
  end

  protected

  # Creates example values for parent id params (i.e. :user_id => 2)
  def example_parent_values(use_shallow_route=false)
    unless @example_parent_values
      @example_parent_values = {}
      parent_model_names.each_with_index do |parent_model, index|
        @example_parent_values["#{parent_model}_id"] = index + 2
      end
    end
    use_shallow_route ? @example_parent_values[0..-2] : @example_parent_values
  end

end