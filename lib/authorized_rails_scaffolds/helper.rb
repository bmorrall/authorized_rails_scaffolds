module AuthorizedRailsScaffolds
  class Helper
    include ResourceMacros

    def initialize(options = {})
      # @local_class_name = options[:local_class_name]
      @var_name = options[:var_name] || options[:file_name] # Non-namespaced variable name

      # Pluralized non-namespaced variable name
      @plural_var_name ||= options[:plural_var_name] || @var_name.pluralize

      # Determine namespace prefix i.e awesome
      @namespace_prefix = options[:namespace_prefix] || options[:singular_table_name][0..-(@var_name.length + 2)]

      # Determine Parent Prefix i.e. user_company
      parent_prefix = AuthorizedRailsScaffolds.config.parent_models.collect{ |x| x.underscore }.join('_')

      # Route Prefix i.e. awesome_user_company
      route_prefix = [@namespace_prefix, parent_prefix].reject{ |x|x.blank? }.join('_')
      @route_prefix = route_prefix.blank? ? '' : "#{route_prefix}_"

      @parent_variables = AuthorizedRailsScaffolds.config.parent_models.collect{ |x| "@#{x.underscore}" }.join(', ')

      # Route Helpers
      @route_params_prefix = @parent_variables.blank? ? "" : "#{@parent_variables}, "
      @index_path_prefix = "#{@route_prefix}#{@plural_var_name}"
      @single_path_prefix = "#{@route_prefix}#{var_name}"
    end

    # Non-namespaced variable name (i.e. foo_bar)
    def var_name
      @var_name
    end

    def plural_var_name
      @plural_var_name
    end

    def controller_show_route(variable = nil)
      variable ||= ""
      if variable.blank?
        "#{@single_path_prefix}_path(#{@parent_variables})"
      else
        "#{@single_path_prefix}_path(#{@route_params_prefix}#{variable})"        
      end
    end

    def controller_index_path
      if @parent_variables.blank?
        "#{@index_path_prefix}_path"
      else
        "#{@index_path_prefix}_path(#{@parent_variables})"
      end
    end

    def controller_index_route
      if @parent_variables.blank?
        "#{@index_path_prefix}_url"
      else
        "#{@index_path_prefix}_url(#{@parent_variables})"
      end
    end

    # call arguments
    def index_action_params_prefix
      if AuthorizedRailsScaffolds.config.parent_models.any?
        AuthorizedRailsScaffolds.config.parent_models.collect{|x| ":#{x.underscore}_id => @#{x.underscore}.to_param"}.join(', ')
      else
        ''
      end
    end

    def references_show_route(attribute_name, variable = nil)
      variable ||= "@#{@var_name}.#{attribute_name}"
      if AuthorizedRailsScaffolds.config.parent_models.any? && AuthorizedRailsScaffolds.config.parent_models.last.underscore == attribute_name
        references_path = "#{@route_prefix}path(#{variable})"
      else
        references_path = "#{attribute_name}_path(#{variable})"
        unless @namespace_prefix.blank?
        references_path = "#{@namespace_prefix}_#{references_path}"
      end
      end
      references_path
    end

    def action_params_prefix
      index_action_params = index_action_params_prefix
      if index_action_params.blank?
        ''
      else
        "#{index_action_params}, "
      end
    end

    # Returns code that will generate attribute_value as an attribute_type
    def factory_attribute_value(attribute_type, attribute_value)
      case attribute_type
      when :datetime
        "DateTime.parse(#{attribute_value})"
      when :time
        value_as_time = attribute_value.to_time.strftime('%T')
        "Time.parse(#{value_as_time.dump})"
      when :date
        value_as_date = attribute_value.to_time.strftime('%Y-%m-%d')
        "Date.parse(#{value_as_date.dump})"
      else
        attribute_value
      end
    end

    # Returns the expected output string of attribute_value if it is an attribute_type
    def factory_attribute_string(attribute_type, attribute_value)
      case attribute_type
      when :datetime
        attribute_value_as_date = DateTime.parse(attribute_value)
        I18n.l(attribute_value_as_date, :format => :long).dump
      when :time
        attribute_value_as_time = Time.parse(attribute_value)
        I18n.l(attribute_value_as_time, :format => :short).dump
      when :date
        attribute_value_as_date = Date.parse(attribute_value)
        I18n.l(attribute_value_as_date).dump
      else
        attribute_value
      end
    end

  end
  
end