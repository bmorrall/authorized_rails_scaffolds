module RouteExampleMacros

  # Example index route: i.e. /awesome/users/2/foo_bars
  def example_controller_path
    unless @example_controller_path
      example_controller_path_parts = []

      parent_model_tables.each do |parent_model|
        # users, 2
        parent_value = example_parent_values["#{parent_model}_id"]
        example_controller_path_parts << parent_model.pluralize
        example_controller_path_parts << parent_value
      end

      # Example index route: i.e. /awesome/users/2/foo_bars
      @example_controller_path = [parent_module_groups + example_controller_path_parts + [resource_table_name.pluralize]].join("/")
    end
    "/#{@example_controller_path}"
  end

  # Extra params for an example controller path: i.e. ', :user_id => 2'
  def example_controller_path_extra_params
    @example_controller_path_extra_params ||= example_parent_values.any? ? ', ' + example_parent_values.map{ |parent_model_id, parent_value| ":#{parent_model_id} => \"#{parent_value}\"" }.join(', ') : ''
  end

  protected

  # Creates example values for parent id params (i.e. :user_id => 2)
  def example_parent_values
    unless @example_parent_values
      @example_parent_values = {}
      parent_model_tables.each_with_index do |parent_model, index|
        @example_parent_values["#{parent_model}_id"] = index + 2
      end
    end
    @example_parent_values
  end

end