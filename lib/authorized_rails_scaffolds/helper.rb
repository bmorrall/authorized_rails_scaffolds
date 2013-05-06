module AuthorizedRailsScaffolds
  class Helper
    include ResourceMacros
    include PathMacros

    def initialize(options = {})
      # @local_class_name = options[:local_class_name]
      @var_name = options[:var_name] || options[:file_name] # Non-namespaced variable name

      # Pluralized non-namespaced variable name
      @plural_var_name ||= options[:plural_var_name]

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

    def parent_variables
      @parent_variables ||= parent_model_tables.collect{ |parent_table| parent_variable(parent_table) }
    end

  end
end
