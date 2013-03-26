module AuthorizedRailsScaffolds

  PARENT_MODELS = [] # i.e. ['Category', 'User'] for Awesome/FooBar => awesome_category_user_foo_bars_path

  class Helper

    def initalize(class_name, singular_table_name, file_name, plural_file_name = nil)
      @local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
      @var_name = file_name # Non-namespaced variable name
      @plural_var_name = plural_file_name || file_name.pluralize # Pluralized non-namespaced variable name

      # Determine namespace prefix i.e awesome
      @namespace_prefix = singular_table_name[0..-(file_name.length + 2)]

      # Determine Parent Prefix i.e. user_company
      parent_prefix = AuthorizedRailsScaffolds::PARENT_MODELS.collect{ |x| x.underscore }.join('_')
      parent_prefix = "#{parent_prefix}_" unless parent_prefix.blank?

      # Route Prefix i.e. awesome_user_company
      @route_prefix = namespace_prefix.blank? ? parent_prefix : "#{namespace_prefix}_#{parent_prefix}"

      @parent_variables = AuthorizedRailsScaffolds::PARENT_MODELS.collect{ |x| "@#{x.underscore}" }.join(', ')

      # Route Helpers
      @route_params_prefix = @parent_variables.blank? ? "" : "#{@parent_variables}, "
      @index_path_prefix = "#{@route_prefix}#{@plural_var_name}"
      @single_path_prefix = "#{@route_prefix}#{var_name}"
    end

    def local_class_name
      @local_class_name
    end

    def var_name
      @var_name
    end

    def plural_var_name
      @plural_var_name
    end

    def controller_show_route(variable = nil)
      variable ||= "@#{@var_name}"
      params+prefix
      "#{@single_path_prefix}_path(#{@route_params_prefix}#{variable})"
    end

    def controller_index_route
      if @parent_variables.blank?
        "#{@index_path_prefix}_url"
      else
        "#{@index_path_prefix}_url(#{@parent_variables})"
      end
    end

  end

end

