require 'spec_helper'

describe AuthorizedRailsScaffolds::RSpecScaffoldRoutingHelper do
  include RSpecScaffoldRoutingHelperMacros

  describe '#controller_class_name' do
    context 'with no parent modules' do
      it 'returns the pluralized class_name with Controller appended' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
    context 'with a parent modules' do
      it 'returns the pluralized controller class name nested within the parent module' do
        subject = build_routing_spec_helper :class_name => 'Example::FooBar'
        subject.controller_class_name.should eq('Example::FooBarsController')
      end
    end
    context 'with multiple parent modules' do
      it 'returns the pluralized controller class name nested within the parent modules' do
        subject = build_routing_spec_helper :class_name => 'Example::V1::FooBar'
        subject.controller_class_name.should eq('Example::V1::FooBarsController')
      end
    end
    context 'with generated controller_class_name value' do
      it 'returns the generated controller_class_name with Controller appended' do
        subject = build_routing_spec_helper :controller_class_name => 'Example::V1::FooBars'
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
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
  end

  describe '#example_index_path' do
    it 'underscores the class_name value' do
      subject = build_routing_spec_helper :class_name => 'FooBar'
      subject.example_index_path.should eq('/foo_bars')
    end
    it 'adds parent_models to the file path' do
      subject = build_routing_spec_helper :class_name => 'Example::FooBar'
      subject.example_index_path.should eq('/example/foo_bars')
    end
    it 'adds multiple parent_models to the file path' do
      subject = build_routing_spec_helper :class_name => 'Example::V1::FooBar'
      subject.example_index_path.should eq('/example/v1/foo_bars')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'adds the parent model before the class name' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.example_index_path.should eq('/parents/2/foo_bars')
      end
      it 'adds the parent model after the parent module' do
        subject = build_routing_spec_helper :class_name => 'Example::FooBar'
        subject.example_index_path.should eq('/example/parents/2/foo_bars')
      end
      it 'adds the parent model after multiple parent module' do
        subject = build_routing_spec_helper :class_name => 'Example::V1::FooBar'
        subject.example_index_path.should eq('/example/v1/parents/2/foo_bars')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
        it 'adds the parent models before the class name' do
          subject = build_routing_spec_helper :class_name => 'FooBar'
          subject.example_index_path.should eq('/grandparents/2/parents/3/foo_bars')
        end
        it 'adds the parent models after the parent module' do
          subject = build_routing_spec_helper :class_name => 'Example::FooBar'
          subject.example_index_path.should eq('/example/grandparents/2/parents/3/foo_bars')
        end
      end
    end
  end

  describe '#example_index_path_extra_params' do
    context 'with no parent models' do
      it 'returns an empty string with no parent module' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.example_index_path_extra_params.should eq('')
      end
      it 'returns an empty string with a parent module' do
        subject = build_routing_spec_helper :class_name => 'Example::FooBar'
        subject.example_index_path_extra_params.should eq('')
      end
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'adds the parent model with a value assigned to it' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.example_index_path_extra_params.should eq(', :parent_id => "2"')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
      end
      it 'adds the parent models with their values' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.example_index_path_extra_params.should eq(', :grandparent_id => "2", :parent_id => "3"')
      end
    end
  end

  describe '#resource_directory' do
    it 'underscores the class_name value' do
      subject = build_routing_spec_helper :class_name => 'FooBar'
      subject.resource_directory.should eq('foo_bars')
    end
    it 'adds parent_models to the file path' do
      subject = build_routing_spec_helper :class_name => 'Example::FooBar'
      subject.resource_directory.should eq('example/foo_bars')
    end
    it 'adds multiple parent_models to the file path' do
      subject = build_routing_spec_helper :class_name => 'Example::V1::FooBar'
      subject.resource_directory.should eq('example/v1/foo_bars')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'ignores the parent_model value' do
        subject = build_routing_spec_helper :class_name => 'FooBar'
        subject.resource_directory.should eq('foo_bars')
      end
    end
  end

end