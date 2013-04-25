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

end