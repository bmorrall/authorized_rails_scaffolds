
module RSpecScaffoldViewHelperMacros

  def build_view_spec_helper(args = {})
    defaults = {
      # class_name: 'Scaffold::Example', # Model class name
      # singular_table_name: 'scaffold_example', # path and model name
      # file_name: 'example', # last part of singular_table_name
      attributes: [],
    }
    defaults.merge! (args)
    AuthorizedRailsScaffolds::RSpecScaffoldViewHelper.new(defaults)
  end

end