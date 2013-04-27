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
      it 'ignores the parent module value' do
        subject = build_rails_controller_spec_helper :class_name => 'FooBar'
        subject.application_controller_class.should eq('ApplicationController')
      end
    end
  end

  describe '#controller_class_name' do
    context 'with no parent modules' do
      it 'returns the pluralized class_name with Controller appended' do
        subject = build_rails_controller_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
    context 'with a parent modules' do
      it 'returns the pluralized controller class name nested within the parent module' do
        subject = build_rails_controller_spec_helper :class_name => 'Example::FooBar'
        subject.controller_class_name.should eq('Example::FooBarsController')
      end
    end
    context 'with multiple parent modules' do
      it 'returns the pluralized controller class name nested within the parent modules' do
        subject = build_rails_controller_spec_helper :class_name => 'Example::V1::FooBar'
        subject.controller_class_name.should eq('Example::V1::FooBarsController')
      end
    end
    context 'with generated controller_class_name value' do
      it 'returns the generated controller_class_name with Controller appended' do
        subject = build_rails_controller_spec_helper :controller_class_name => 'Example::V1::FooBars'
        subject.controller_class_name.should eq('Example::V1::FooBarsController')
      end
    end
    context 'with a parent module' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'ignores the parent module value' do
        subject = build_rails_controller_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
  end

end