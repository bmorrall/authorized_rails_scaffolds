require 'spec_helper'

describe AuthorizedRailsScaffolds::ControllerSpecHelper do

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

end