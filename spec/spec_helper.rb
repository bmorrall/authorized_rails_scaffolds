require "bundler/setup"
Bundler.require

require 'rails'

require 'authorized_rails_scaffolds'
require 'support/rspec_scaffold_generator_helper_macros'

RSpec.configure do |config|
  config.include RSpecScaffoldGeneratorHelperMacros
  # some (optional) config here

  config.after(:each) do
    AuthorizedRailsScaffolds.configure do |config|
      config.parent_models = []
    end
  end
end