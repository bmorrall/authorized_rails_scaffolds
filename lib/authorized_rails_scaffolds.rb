require "authorized_rails_scaffolds/version"

module AuthorizedRailsScaffolds
  
  mattr_accessor :parent_models
  @@parent_models = []
  
end

require "authorized_rails_scaffolds/helper"
require "authorized_rails_scaffolds/view_spec_helper"
