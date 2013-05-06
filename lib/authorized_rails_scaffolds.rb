require "authorized_rails_scaffolds/version"

module AuthorizedRailsScaffolds
  class Configuration
    attr_accessor :parent_models
    attr_accessor :shallow_routes

    def initialize
      self.parent_models = []
      self.shallow_routes = false
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config) if block_given?
  end

  # mattr_accessor :parent_models
  # @@parent_models = []

end

require "authorized_rails_scaffolds/macros/controller_macros"
require "authorized_rails_scaffolds/macros/factory_macros"
require "authorized_rails_scaffolds/macros/path_macros"
require "authorized_rails_scaffolds/parent_macros"
require "authorized_rails_scaffolds/macros/resource_macros"
require "authorized_rails_scaffolds/macros/route_example_macros"
require "authorized_rails_scaffolds/macros/test_var_macros"
require "authorized_rails_scaffolds/helper"

# Rails Helpers
require "authorized_rails_scaffolds/rails_scaffold_controller_helper"
require "authorized_rails_scaffolds/rails_helper_helper"

# Erb Helpers
require "authorized_rails_scaffolds/rails_erb_scaffold_helper"

# RSpec Helpers
require "authorized_rails_scaffolds/rspec_scaffold_helper"
require "authorized_rails_scaffolds/rspec_scaffold_controller_helper"
require "authorized_rails_scaffolds/rspec_scaffold_routing_helper"
require "authorized_rails_scaffolds/rspec_scaffold_view_helper"
require "authorized_rails_scaffolds/rspec_integration_helper"

