require "authorized_rails_scaffolds/version"

module AuthorizedRailsScaffolds
  class Configuration
    attr_accessor :parent_models

    def initialize
      self.parent_models = []
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

require "authorized_rails_scaffolds/controller_macros"
require "authorized_rails_scaffolds/factory_macros"
require "authorized_rails_scaffolds/resource_macros"
require "authorized_rails_scaffolds/route_example_macros"
require "authorized_rails_scaffolds/test_var_macros"
require "authorized_rails_scaffolds/helper"
require "authorized_rails_scaffolds/rails_erb_scaffold_helper"
require "authorized_rails_scaffolds/rails_scaffold_controller_helper"
require "authorized_rails_scaffolds/rspec_scaffold_helper"
require "authorized_rails_scaffolds/rspec_scaffold_controller_helper"
require "authorized_rails_scaffolds/rspec_scaffold_routing_helper"
require "authorized_rails_scaffolds/rspec_scaffold_view_helper"

