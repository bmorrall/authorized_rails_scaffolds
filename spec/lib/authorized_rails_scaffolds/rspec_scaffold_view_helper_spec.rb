require 'spec_helper'

describe AuthorizedRailsScaffolds::RSpecScaffoldViewHelper do
  include RSpecScaffoldViewHelperMacros
  pending

  describe '#parent_model_tables' do
    context 'with no parent_models' do
      it 'returns an empty array' do
        subject = build_view_spec_helper
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
        subject = build_view_spec_helper
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
        subject = build_view_spec_helper
        subject.parent_model_tables.should eq(['grandparent', 'parent'])
      end
    end
  end

  describe '#resource_directory' do
    it 'underscores the class_name value' do
      subject = build_view_spec_helper :class_name => 'FooBar'
      subject.resource_directory.should eq('foo_bars')
    end
    it 'adds parent_models to the file path' do
      subject = build_view_spec_helper :class_name => 'Example::FooBar'
      subject.resource_directory.should eq('example/foo_bars')
    end
    it 'adds multiple parent_models to the file path' do
      subject = build_view_spec_helper :class_name => 'Example::V1::FooBar'
      subject.resource_directory.should eq('example/v1/foo_bars')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'ignores the parent_model value' do
        subject = build_view_spec_helper :class_name => 'FooBar'
        subject.resource_directory.should eq('foo_bars')
      end
    end
  end

  describe '#resource_test_sym' do
    it 'returns var_name preceeded by an :' do
      subject = build_view_spec_helper :var_name => 'foo_bar'
      subject.resource_test_sym.should eq(':test_foo_bar')
    end
    it 'appends a number if included' do
      subject = build_view_spec_helper :var_name => 'foo_bar'
      subject.resource_test_sym(2).should eq(':test_foo_bar_2')
    end
  end

  describe '#resource_test_var' do
    it 'returns var_name preceeded by an @' do
      subject = build_view_spec_helper :var_name => 'foo_bar'
      subject.resource_test_var.should eq('@test_foo_bar')
    end
    it 'appends a number if included' do
      subject = build_view_spec_helper :var_name => 'foo_bar'
      subject.resource_test_var(2).should eq('@test_foo_bar_2')
    end
  end

end