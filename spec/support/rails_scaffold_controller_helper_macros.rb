
module RailsScaffoldControllerHelperMacros

  def build_rails_controller_spec_helper(options = {})
    defaults = {
      # class_name: 'Scaffold::Example', # Model class name
      # singular_table_name: 'scaffold_example', # path and model name
      # file_name: 'example', # last part of singular_table_name
      attributes: [],
    }
    defaults.merge! options
    AuthorizedRailsScaffolds::RailsScaffoldControllerHelper.new(defaults)
  end

end