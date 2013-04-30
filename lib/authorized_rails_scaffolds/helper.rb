module AuthorizedRailsScaffolds
  class Helper
    include ResourceMacros

    def initialize(options = {})
      # @local_class_name = options[:local_class_name]
      @var_name = options[:var_name] || options[:file_name] # Non-namespaced variable name

      # Pluralized non-namespaced variable name
      @plural_var_name ||= options[:plural_var_name] || @var_name.pluralize

      # Determine namespace prefix i.e awesome
      # options[:namespace_prefix]

      @singular_table_name = options[:singular_table_name]
    end

    # Non-namespaced variable name (i.e. foo_bar)
    def var_name
      @var_name
    end

    def plural_var_name
      @plural_var_name
    end

    # Route Prefix parts i.e. ['awesome', 'user', 'company']
    def route_prefix_values
      @route_prefix_values ||= [parent_module_groups + parent_model_tables]
    end

    def collection_route_prefix
      @collection_route_prefix ||= [route_prefix_values + [resource_table_name.pluralize]].join('_')
    end

    def member_route_prefix
      @member_route_prefix ||= [route_prefix_values + [resource_table_name]].join('_')
    end

    def parent_variables
      @parent_variables ||= parent_model_tables.collect{ |parent_table| parent_variable(parent_table) }
    end

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

  end
  
end