require 'spec_helper'

describe AuthorizedRailsScaffolds::RSpecScaffoldGeneratorHelper do

  describe '#controller_directory' do
    it 'underscores the class_name value' do
      subject = build_controller_spec_helper :class_name => 'FooBar'
      subject.controller_directory.should eq('foo_bar')
    end
    it 'adds parent_models to the file path' do
      subject = build_controller_spec_helper :class_name => 'Example::FooBar'
      subject.controller_directory.should eq('example/foo_bar')
    end
    it 'adds multiple parent_models to the file path' do
      subject = build_controller_spec_helper :class_name => 'Example::V1::FooBar'
      subject.controller_directory.should eq('example/v1/foo_bar')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'ignores the parent_model value' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.controller_directory.should eq('foo_bar')
      end
    end
  end

  describe '#example_controller_path' do
    it 'underscores the class_name value' do
      subject = build_controller_spec_helper :class_name => 'FooBar'
      subject.example_controller_path.should eq('/foo_bar')
    end
    it 'adds parent_models to the file path' do
      subject = build_controller_spec_helper :class_name => 'Example::FooBar'
      subject.example_controller_path.should eq('/example/foo_bar')
    end
    it 'adds multiple parent_models to the file path' do
      subject = build_controller_spec_helper :class_name => 'Example::V1::FooBar'
      subject.example_controller_path.should eq('/example/v1/foo_bar')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'adds the parent model before the class name' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.example_controller_path.should eq('/parents/2/foo_bar')
      end
      it 'adds the parent model after the parent module' do
        subject = build_controller_spec_helper :class_name => 'Example::FooBar'
        subject.example_controller_path.should eq('/example/parents/2/foo_bar')
      end
      it 'adds the parent model after multiple parent module' do
        subject = build_controller_spec_helper :class_name => 'Example::V1::FooBar'
        subject.example_controller_path.should eq('/example/v1/parents/2/foo_bar')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
        it 'adds the parent models before the class name' do
          subject = build_controller_spec_helper :class_name => 'FooBar'
          subject.example_controller_path.should eq('/grandparents/2/parents/3/foo_bar')
        end
        it 'adds the parent models after the parent module' do
          subject = build_controller_spec_helper :class_name => 'Example::FooBar'
          subject.example_controller_path.should eq('/example//grandparents/2/parents/3/foo_bar')
        end
      end
    end
  end

  describe '#example_controller_path_extra_params' do
    context 'with no parent models' do
      it 'returns an empty string with no parent module' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.example_controller_path_extra_params.should eq('')
      end
      it 'returns an empty string with a parent module' do
        subject = build_controller_spec_helper :class_name => 'Example::FooBar'
        subject.example_controller_path_extra_params.should eq('')
      end
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      it 'adds the parent model with a value assigned to it' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.example_controller_path_extra_params.should eq(', :parent_id => 2')
      end
    end
    context 'with multiple parent models' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Grandparent', 'Parent']
        end
      end
      it 'adds the parent models with their values' do
        subject = build_controller_spec_helper :class_name => 'FooBar'
        subject.example_controller_path_extra_params.should eq(', :grandparent_id => 2, :parent_id => 3')
      end
    end
  end

end