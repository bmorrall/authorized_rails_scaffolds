module PathMacros

  def controller_show_route(variable = nil)
    variables = [] + parent_variables
    variables += [variable] unless variable.nil?
    controller_routes = "#{member_route_prefix}_path"
    controller_routes += "(#{variables.join(', ')})" if variables.any?
    controller_routes
  end

  def controller_index_path
    variables = parent_variables
    controller_index_path = "#{collection_route_prefix}_path"
    controller_index_path += "(#{variables.join(', ')})" if variables.any?
    controller_index_path
  end

  def controller_index_route
    variables = parent_variables
    controller_index_route = "#{collection_route_prefix}_url"
    controller_index_route += "(#{variables.join(', ')})" if variables.any?
    controller_index_route
  end

  def references_show_route(attribute_name, variable = nil)
    variable ||= "#{resource_var}.#{attribute_name}"
    path_variables = [parent_module_groups + [attribute_name]]

    references_show_route = path_variables.join('_')
    references_show_route += "_path(#{variable})"
    references_show_route
  end

  def collection_route_prefix
    @collection_route_prefix ||= (route_prefix_values + [resource_table_name.pluralize]).join('_')
  end

  def member_route_prefix
    @member_route_prefix ||= (route_prefix_values + [resource_table_name]).join('_')
  end

  def parent_variables
    @parent_variables ||= parent_model_tables.collect{ |parent_table| parent_variable(parent_table) }
  end

  # Route Prefix parts i.e. ['awesome', 'user', 'company']
  def route_prefix_values
    unless @route_prefix_values
      @route_prefix_values = parent_module_groups || []
      @route_prefix_values += parent_model_tables
      @route_prefix_values = @route_prefix_values.reject{|x|x.blank?}
    end
    @route_prefix_values
  end

end