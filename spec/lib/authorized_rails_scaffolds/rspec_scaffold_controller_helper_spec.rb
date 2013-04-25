require 'spec_helper'

describe AuthorizedRailsScaffolds::RSpecScaffoldControllerHelper do
  include RSpecScaffoldControllerHelperMacros

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