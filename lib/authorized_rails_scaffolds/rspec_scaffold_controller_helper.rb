class AuthorizedRailsScaffolds::RSpecScaffoldControllerHelper < AuthorizedRailsScaffolds::RSpecScaffoldHelper

  def create_factory_model
    extra_params = extra_model_params
    "FactoryGirl.create(:#{var_name}#{extra_params})"
  end

  def create_parent_model(model_name)
    extra_params = extra_model_params(model_name)
    "FactoryGirl.create(:#{model_name}#{extra_params})"
  end

  protected

  def extra_model_params(model_name = nil)
    argument_params = []
    parent_model_tables.each do |parent_model|
      attribute = parent_model.underscore
      break if model_name == attribute
      argument_params << ", :#{attribute} => @#{attribute}"
    end
    argument_params.join('')
  end

end