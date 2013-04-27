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

  describe '#create_resource_from_factory' do
    context 'with no parent_models' do
      it 'returns a code fragment that creates the model' do
        subject = build_controller_spec_helper :var_name => 'foo_bar'
        subject.create_resource_from_factory.should eq('FactoryGirl.create(:foo_bar)')
      end
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'returns a code fragment including the parent reference' do
        subject = build_controller_spec_helper :var_name => 'foo_bar'
        subject.create_resource_from_factory.should eq('FactoryGirl.create(:foo_bar, :parent => @parent)')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
      end
      it 'returns a code fragment including the last parent fragment' do
        subject = build_controller_spec_helper :var_name => 'foo_bar'
        subject.create_resource_from_factory.should eq('FactoryGirl.create(:foo_bar, :parent => @parent)')
      end
    end
  end

  describe '#create_parent_resource_from_factory' do
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'returns a code fragment with no parent references' do
        subject = build_controller_spec_helper
        subject.create_parent_resource_from_factory('parent').should eq('FactoryGirl.create(:parent)')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
      end
      it 'returns last parent fragment with a references to the grandparent' do
        subject = build_controller_spec_helper
        subject.create_parent_resource_from_factory('parent').should eq('FactoryGirl.create(:parent, :grandparent => @grandparent)')
      end
      it 'returns the grandparent element with no references to other classes' do
        subject = build_controller_spec_helper
        subject.create_parent_resource_from_factory('grandparent').should eq('FactoryGirl.create(:grandparent)')
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

  describe '#resource_var' do
    it 'returns var_name preceeded by an @' do
      subject = build_controller_spec_helper :var_name => 'foo_bar'
      subject.resource_var.should eq('@foo_bar')
    end
    context 'with a parent module' do
      it 'falls back to using class_name if var_name is not present' do
        subject = build_controller_spec_helper :var_name => nil, :class_name => 'Example::FooBar'
        subject.resource_var.should eq('@foo_bar')
      end
    end
  end

  describe '#resource_test_var' do
    it 'returns var_name preceeded by an @' do
      subject = build_controller_spec_helper :var_name => 'foo_bar'
      subject.resource_test_var.should eq('@foo_bar')
    end
  end

end