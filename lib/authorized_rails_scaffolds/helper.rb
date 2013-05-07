module AuthorizedRailsScaffolds
  class Helper
    include Macros::ParentMacros
    include Macros::PathMacros
    include Macros::ResourceMacros

    def initialize(options = {})
      # @local_class_name = options[:local_class_name]

      # Fix for potentially plural file_name value
      file_name = options[:file_name]
      file_name = file_name.singularize unless file_name.nil?

      @var_name = options[:var_name] || file_name # Non-namespaced variable name

      # Pluralized non-namespaced variable name
      @plural_var_name ||= options[:plural_var_name]

      # Determine namespace prefix i.e awesome
      # options[:namespace_prefix]

      @singular_table_name = options[:singular_table_name]

      @human_name = options[:human_name]
    end

    # Non-namespaced variable name (i.e. foo_bar)
    def var_name
      @var_name
    end

    def plural_var_name
      @plural_var_name
    end

    def shallow_routes?
      !!AuthorizedRailsScaffolds.config.shallow_routes
    end

  end
end
