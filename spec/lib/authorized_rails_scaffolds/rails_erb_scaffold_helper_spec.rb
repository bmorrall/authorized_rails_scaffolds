require 'spec_helper'

describe AuthorizedRailsScaffolds::RailsErbScaffoldHelper do
  include RailsErbScaffoldHelperMacros

  describe '#scoped_values_for_form' do
    context 'with no parent modules' do
      it 'returns the resource variable' do
        subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
        subject.scoped_values_for_form.should eq('@foo_bar')
      end
    end
    context 'with a parent modules' do
      it 'returns a array with the parent module symbol and the resource variable' do
        subject = build_rails_erb_scaffold_spec_helper :class_name => 'Example::FooBar', :var_name => 'foo_bar'
        subject.scoped_values_for_form.should eq('[:example, @foo_bar]')
      end
    end
    context 'with multiple parent modules' do
      it 'returns a array with all parent modules as symbols and the resource variable' do
        subject = build_rails_erb_scaffold_spec_helper :class_name => 'Example::V1::FooBar', :var_name => 'foo_bar'
        subject.scoped_values_for_form.should eq('[:example, :v1, @foo_bar]')
      end
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      context 'with no parent modules' do
        it 'returns a array with the parent model and the resource variable' do
          subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
          subject.scoped_values_for_form.should eq('[@parent, @foo_bar]')
        end
      end
      context 'with a parent modules' do
        it 'returns a array with the parent modules, the parent model and the resource variable' do
          subject = build_rails_erb_scaffold_spec_helper :class_name => 'Example::FooBar', :var_name => 'foo_bar'
          subject.scoped_values_for_form.should eq('[:example, @parent, @foo_bar]')
        end
      end
    end
  end

  describe '#resource_var' do
    it 'returns var_name preceeded by an @' do
      subject = build_rails_erb_scaffold_spec_helper :var_name => 'foo_bar'
      subject.resource_var.should eq('@foo_bar')
    end
    context 'with a parent module' do
      it 'falls back to using class_name if var_name is not present' do
        subject = build_rails_erb_scaffold_spec_helper :var_name => nil, :class_name => 'Example::FooBar'
        subject.resource_var.should eq('@foo_bar')
      end
    end
  end

end