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
    "#{example_index_path}/1"
  end

  # Extra params for an example controller path: i.e. ', :user_id => 2'
  def example_index_path_extra_params
    @example_index_path_extra_params ||= example_parent_values.any? ? ', ' + example_parent_values.map{ |parent_model_id, parent_value| ":#{parent_model_id} => \"#{parent_value}\"" }.join(', ') : ''
  end

  def example_route_extra_params
    @example_route_extra_params ||= parent_model_names.collect{ |parent_table| ":#{parent_table}_id => #{references_test_name(parent_table)}.to_param" }
  end

  protected

  # Creates example values for parent id params (i.e. :user_id => 2)
  def example_parent_values
    unless @example_parent_values
      @example_parent_values = {}
      parent_model_names.each_with_index do |parent_model, index|
        @example_parent_values["#{parent_model}_id"] = index + 2
      end
    end
    @example_parent_values
  end

end