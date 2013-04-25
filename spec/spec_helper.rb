require "bundler/setup"
Bundler.require

require 'rails'

require 'authorized_rails_scaffolds'
require 'support/controller_spec_helper_support'

RSpec.configure do |config|
  config.include ControllerSpecHelperSupport
  # some (optional) config here
end