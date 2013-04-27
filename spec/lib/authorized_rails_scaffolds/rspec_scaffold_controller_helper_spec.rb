require 'spec_helper'

describe AuthorizedRailsScaffolds::RSpecScaffoldControllerHelper do
  include RSpecScaffoldControllerHelperMacros

  describe '#controller_class_name' do
    context 'with no parent modules' do
      it 'returns the pluralized class_name with Controller appended' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
    context 'with a parent modules' do
      it 'returns the pluralized controller class name nested within the parent module' do
        subject = build_controller_spec_helper :class_name => 'Example::FooBar'
        subject.controller_class_name.should eq('Example::FooBarsController')
      end
    end
    context 'with multiple parent modules' do
      it 'returns the pluralized a controller class name nested within the parent modules' do
        subject = build_controller_spec_helper :class_name => 'Example::V1::FooBar'
        subject.controller_class_name.should eq('Example::V1::FooBarsController')
      end
    end
    context 'with generated controller_class_name value' do
      it 'returns the generated controller_class_name with Controller appended' do
        subject = build_controller_spec_helper :controller_class_name => 'Example::V1::FooBars'
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
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.controller_class_name.should eq('FooBarsController')
      end
    end
  end

  describe '#parent_model_tables' do
    context 'with no parent_models' do
      it 'returns an empty array' do
        subject = build_controller_spec_helper
        subject.parent_model_tables.should eq([])
      end
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'returns an array containing the models table name' do
        subject = build_controller_spec_helper
        subject.parent_model_tables.should eq(['parent'])
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
      end
      it 'returns an array containing all model table names' do
        subject = build_controller_spec_helper
        subject.parent_model_tables.should eq(['grandparent', 'parent'])
      end
    end
  end


end