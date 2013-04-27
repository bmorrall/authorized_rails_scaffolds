require 'spec_helper'

describe AuthorizedRailsScaffolds::RailsScaffoldControllerHelper do
  include RailsScaffoldControllerHelperMacros

  describe '#application_controller_class' do
    context 'with no parent modules' do
      it 'returns a default ApplicationController' do
        subject = build_rails_controller_spec_helper :class_name => 'FooBar'
        subject.application_controller_class.should eq('ApplicationController')
      end
    end
    context 'with a parent modules' do
      it 'returns a ApplicationController nested within the parent module' do
        subject = build_rails_controller_spec_helper :class_name => 'Example::FooBar'
        subject.application_controller_class.should eq('Example::ApplicationController')
      end
    end
    context 'with multiple parent modules' do
      it 'returns a ApplicationController nested within the parent modules' do
        subject = build_rails_controller_spec_helper :class_name => 'Example::V1::FooBar'
        subject.application_controller_class.should eq('Example::V1::ApplicationController')
      end
    end
    context 'with a parent module' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'returns a default ApplicationController' do
        subject = build_rails_controller_spec_helper :class_name => 'FooBar'
        subject.application_controller_class.should eq('ApplicationController')
      end
    end
  end

end