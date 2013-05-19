require 'spec_helper'

describe AuthorizedRailsScaffolds::RailsScaffoldControllerHelper do
  include RailsScaffoldControllerHelperMacros

  describe 'template variables' do
    context 'within nested modules' do
      let(:subject) do
        build_rails_controller_spec_helper :class_name => 'Example::FooBar'
      end
      it { subject.resource_class.should eq('FooBar') }
      it { subject.resource_human_name.should eq('Foo bar') }
      it { subject.resource_symbol.should eq(':foo_bar') }
      it { subject.resource_name.should eq('foo_bar') }
      it { subject.resource_array_name.should eq('foo_bars') }
      it { subject.resource_var.should eq('@foo_bar') }
      it { subject.resource_array_var.should eq('@foo_bars') }

      it { subject.example_controller_path.should eq("/example/foo_bars") }
    end
    context 'within nested modules and parent parent models' do
      let(:subject) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
        build_rails_controller_spec_helper :class_name => 'Example::FooBar'
      end
      it { subject.resource_class.should eq('FooBar') }
      it { subject.resource_human_name.should eq('Foo bar') }
      it { subject.resource_symbol.should eq(':foo_bar') }
      it { subject.resource_name.should eq('foo_bar') }
      it { subject.resource_array_name.should eq('foo_bars') }
      it { subject.resource_var.should eq('@foo_bar') }
      it { subject.resource_array_var.should eq('@foo_bars') }

      it { subject.example_controller_path.should eq("/example/parents/2/foo_bars") }
    end
  end

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

  describe '#resource_var' do
    it 'returns var_name preceeded by an @' do
      subject = build_rails_controller_spec_helper :var_name => 'foo_bar'
      subject.resource_var.should eq('@foo_bar')
    end
    context 'with a parent module' do
      it 'falls back to using class_name if var_name is not present' do
        subject = build_rails_controller_spec_helper :var_name => nil, :class_name => 'Example::FooBar'
        subject.resource_var.should eq('@foo_bar')
      end
    end
  end

end