require 'spec_helper'

<%-
# class_name
# table_name
# index_helper

t_helper = AuthorizedRailsScaffolds::RSpecIntegrationHelper.new(
  :class_name => class_name,
  :table_name => table_name
)

resource_plural_name = t_helper.resource_plural_name
resource_table_name = t_helper.resource_table_name
resource_test_var = t_helper.resource_test_var

parent_model_tables = t_helper.parent_model_tables


-%>
describe "<%= class_name.pluralize %>" do

<%- if parent_model_tables.any? -%>
<%- parent_model_tables.each do |parent_model| -%>
  let(<%= t_helper.references_test_sym(parent_model) %>) { <%= t_helper.create_parent_resource_from_factory parent_model %> }
<%- end -%>

<%- end -%>
  describe "GET <%= t_helper.example_controller_path %>" do
    context "as a user" do
      before(:each) { sign_in_user }
      it "renders a list of <%= resource_plural_name %><%= t_helper.extra_comments %>" do
        2.times { <%= t_helper.create_resource_from_factory %> }
        get <%= t_helper.controller_index_route %>
        response.status.should be(200)
      end
    end
  end

  describe "GET <%= t_helper.example_controller_path %>/1" do
    context "as a user" do
      before(:each) { sign_in_user }
      it "renders a <%= resource_table_name %><%= t_helper.extra_comments %>" do
        <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
        get <%= t_helper.controller_show_route resource_test_var %>
        response.status.should be(200)
      end
    end
  end

  describe "GET <%= t_helper.example_controller_path %>/new" do
    context "as a user" do
      before(:each) { sign_in_user }
      it "renders a form for a new <%= resource_table_name %><%= t_helper.extra_comments %>" do
        get new_<%= t_helper.controller_show_route %>
        response.status.should be(200)
      end
    end
  end

  describe "GET <%= t_helper.example_controller_path %>/1/edit" do
    context "as a user" do
      before(:each) { sign_in_user }
      it "renders the edit form for a <%= resource_table_name %>" do
        <%= resource_test_var %> = <%= t_helper.create_resource_from_factory %>
        get edit_<%= t_helper.controller_show_route resource_test_var %>
        response.status.should be(200)
      end
    end
  end

end
