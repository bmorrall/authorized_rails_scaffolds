module AuthorizedRailsScaffolds::Macros::PathMacros

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

  def controller_show_route(variable = nil)
    variables = [] + parent_variables
    variables += [variable] unless variable.nil?
    controller_routes = "#{member_route_prefix}_path"
    controller_routes += "(#{variables.join(', ')})" if variables.any?
    controller_routes
  end

  def controller_show_route(variable)
    variables = []
    variables += parent_variables(shallow_routes?)
    variables += [variable] unless variable.nil?
    controller_routes = "#{member_route_prefix(shallow_routes?)}_path"
    controller_routes += "(#{variables.join(', ')})" if variables.any?
    controller_routes
  end

  def controller_edit_route(variable)
    "edit_#{controller_show_route(variable)}"
  end

  def controller_new_route
    controller_routes = "#{member_route_prefix}_path"
    controller_routes += "(#{parent_variables.join(', ')})" if parent_variables.any?
    "new_#{controller_routes}"
  end

  def references_show_route(attribute_name, variable = nil)
    variable ||= "#{resource_var}.#{attribute_name}"
    path_variables = [parent_module_groups + [attribute_name]]

    references_show_route = path_variables.join('_')
    references_show_route += "_path(#{variable})"
    references_show_route
  end

  protected

  # Route Prefix parts i.e. ['awesome', 'user', 'company']
  def route_prefix_values(use_shallow_route=false)
    route_prefix_values = parent_module_groups || []
    route_prefix_values += use_shallow_route ? parent_model_names[0..-2] : parent_model_names
    route_prefix_values = route_prefix_values.reject{|x|x.blank?}
  end

  def collection_route_prefix
    @collection_route_prefix ||= (route_prefix_values + [resource_array_name]).join('_')
  end

  def member_route_prefix(use_shallow_route=false)
    (route_prefix_values(use_shallow_route) + [resource_name]).join('_')
  end

end