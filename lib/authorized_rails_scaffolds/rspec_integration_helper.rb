class AuthorizedRailsScaffolds::RSpecIntegrationHelper < AuthorizedRailsScaffolds::RSpecScaffoldHelper
  include FactoryMacros
  include RouteExampleMacros

  def extra_comments
    parent_models.any? ? " belonging to a #{parent_models[-1]}" : ''
  end

end