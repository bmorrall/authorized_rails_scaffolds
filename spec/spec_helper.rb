require "bundler/setup"
Bundler.require

require 'rails'

require 'authorized_rails_scaffolds'
require 'support/rspec_scaffold_controller_helper_macros'
require 'support/rspec_scaffold_routing_helper_macros'
require 'support/rspec_scaffold_view_helper_macros'

RSpec.configure do |config|
  # some (optional) config here

  config.after(:each) do
    AuthorizedRailsScaffolds.configure do |config|
      config.parent_models = []
    end
  end
end