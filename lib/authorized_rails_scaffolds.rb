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

require "authorized_rails_scaffolds/helper"
require "authorized_rails_scaffolds/controller_spec_helper"
require "authorized_rails_scaffolds/routing_spec_helper"
require "authorized_rails_scaffolds/view_spec_helper"
