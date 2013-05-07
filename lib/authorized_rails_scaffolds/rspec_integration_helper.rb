class AuthorizedRailsScaffolds::RSpecIntegrationHelper < AuthorizedRailsScaffolds::RSpecScaffoldHelper
  include AuthorizedRailsScaffolds::Macros::FactoryMacros
  include AuthorizedRailsScaffolds::Macros::RouteExampleMacros

  def extra_comments
    parent_models.any? ? " belonging to a #{parent_models[-1]}" : ''
  end

end