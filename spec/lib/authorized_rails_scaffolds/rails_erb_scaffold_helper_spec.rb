require 'spec_helper'

describe AuthorizedRailsScaffolds::RailsErbScaffoldHelper do
  include RailsErbScaffoldHelperMacros

  describe '#controller_show_route' do
    it 'returns a single route to the resource' do
      subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
      subject.controller_show_route.should eq('foo_bar_path')
    end
    it 'returns appends the included value to the root' do
      subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
      subject.controller_show_route('@foo_bar').should eq('foo_bar_path(@foo_bar)')
    end
    context 'with a parent model' do
      before(:each) do
        AuthorizedRailsScaffolds.configure do |config|
          config.parent_models = ['Parent']
        end
      end
      context 'with no parent modules' do
        before(:each) do
          @subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
        end
        it 'returns a path within the parent models' do
          @subject.controller_show_route.should eq('parent_foo_bar_path(@parent)')
        end
        it 'returns a path with the resource within the parent models' do
          @subject.controller_show_route('@foo_bar').should eq('parent_foo_bar_path(@parent, @foo_bar)')
        end
      end
      context 'with a parent modules' do
        before(:each) do
          @subject = build_rails_erb_scaffold_spec_helper :class_name => 'Awesome::FooBar', :var_name => 'foo_bar'
        end
        it 'returns a path within the module and with parent models' do
          @subject.controller_show_route.should eq('awesome_parent_foo_bar_path(@parent)')
        end
        it 'returns a path with the resource within the module and with parent models' do
          @subject.controller_show_route('@foo_bar').should eq('awesome_parent_foo_bar_path(@parent, @foo_bar)')
        end
      end
    end
    
  end

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