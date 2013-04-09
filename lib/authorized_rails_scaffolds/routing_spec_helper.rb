class AuthorizedRailsScaffolds::RoutingSpecHelper

  def initialize(options = {})
    @ns_table_name = options[:ns_table_name]
  end

  def extra_params
    extra_params = ''
    AuthorizedRailsScaffolds.parent_models.each_with_index do |model, model_index|
      extra_params += ", :#{model.underscore}_id => \"#{model_index + 2}\""
    end
    extra_params
  end

  def request_path
    # Remove last part of the path
    parts = @ns_table_name.split('/')[0..-2] || []

    AuthorizedRailsScaffolds.parent_models.each_with_index do |model, model_index|
      parts << model.underscore.pluralize
      parts << model_index + 2
    end

    # Add Final Part
    parts << @ns_table_name.split('/')[-1]
    parts.join('/')
  end

end