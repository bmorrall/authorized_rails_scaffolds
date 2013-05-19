require 'spec_helper'

describe AuthorizedRailsScaffolds::RailsErbScaffoldHelper do
  include RailsErbScaffoldHelperMacros

  describe '#controller_show_route' do
    it 'returns a single route to the resource' do
      subject = build_rails_erb_scaffold_spec_helper :class_name => 'FooBar', :var_name => 'foo_bar'
      subject.controller_new_route.should eq('new_foo_bar_path')
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
          @subject.controller_new_route.should eq('new_parent_foo_bar_path(@parent)')
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
          @subject.controller_new_route.should eq('new_awesome_parent_foo_bar_path(@parent)')
        end
        it 'returns a path with the resource within the module and with parent models' do
          @subject.controller_show_route('@foo_bar').should eq('awesome_parent_foo_bar_path(@parent, @foo_bar)')
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