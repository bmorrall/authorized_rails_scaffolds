require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldViewHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

resource_directory = t_helper.resource_directory
parent_model_tables = t_helper.parent_model_tables

local_class_name = t_helper.local_class_name # Non-Namespaced class name
resource_table_name = t_helper.resource_table_name

output_attributes = t_helper.output_attributes
datetime_attributes = t_helper.datetime_attributes
references_attributes = t_helper.references_attributes
standard_attributes = t_helper.standard_attributes

-%>
describe "<%= resource_directory %>/index" do

<% parent_model_tables.each_with_index do |parent_model, index| -%>
<%- if index == 0 -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>) }
<%- else -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>, :<%= parent_model_tables[index - 1] %> => <%= parent_model_tables[index - 1] %>) }
<%- end -%>
<%- end -%>
<% [1,2].each_with_index do |id, model_index| -%>
  let(:<%= resource_table_name %>_<%= id %>) do
    FactoryGirl.build_stubbed(:<%= resource_table_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <% if attribute.type == :references && parent_model_tables.include?(attribute.name) %><%= attribute.name %><% else %><%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><% end %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    )\n" -%>
  end
<% end -%>

  context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
    before(:each) do
      # Add Properties for view scope
<%- parent_model_tables.each do |parent_model| -%>
      assign(:<%= parent_model %>, @<%= parent_model %> = <%= parent_model %>)
<%- end -%>
<% [1,2].each_with_index do |id, model_index| -%>
      <%= t_helper.resource_test_var(id) %> = <%= resource_table_name %>_<%= id %>
<% end -%>
      assign(:<%= t_helper.resource_plural_name %>, [
<% [1,2].each_with_index do |id, model_index| -%>
        <%= t_helper.resource_test_var(id) %><%= model_index == 1 ? '' : ',' %>
<% end -%>
      ])

      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
    end

    describe "page header" do
      it 'includes a h1 title' do
        render
<% if webrat? -%>
        rendered.should have_selector(".page-header>h1", :content => <%= resource_table_name.humanize.pluralize.dump %>, :count => 1)
<% else -%>
        assert_select ".page-header>h1", :text => <%= resource_table_name.humanize.pluralize.dump %>, :count => 1
<% end -%>
      end
    end

    describe "<%= t_helper.resource_plural_name %> table" do
      it 'includes a row for each <%= resource_table_name %>' do
        render
<% unless webrat? -%>
        # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
        rendered.should have_selector("table>tbody>tr.<%= resource_table_name %>_#{<%= t_helper.resource_test_var(model_index) %>.id}", :count => 1)
<% else -%>
        assert_select "table>tbody>tr.<%= resource_table_name %>_#{<%= t_helper.resource_test_var(model_index) %>.id}", :count => 1
<% end -%>
<% end -%>
      end

      it "contains a list of <%= t_helper.resource_plural_name %>" do
        render
<% if webrat? -%>
  <%- [1,2].each do |model_index| -%>
        rendered.should have_selector("tr>td.id-column", :content => <%= t_helper.resource_test_var(model_index) %>.id.to_s, :count => 1)
  <%- end -%>
  <%- standard_attributes.each_with_index do |attribute, attribute_index| -%>
        rendered.should have_selector("tr>td", :content => <%= factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2)
  <%- end -%>
  <%- datetime_attributes.each_with_index do |attribute, attribute_index| -%>
        rendered.should have_selector("tr>td", :content => <%= factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2)
  <%- end -%>
<% else -%>
        # Run the generator again with the --webrat flag if you want to use webrat matchers
  <%- [1,2].each do |model_index| -%>
        assert_select "tr>td.id-column", :text => <%= t_helper.resource_test_var(model_index) %>.id.to_s, :count => 1
  <%- end -%>
  <%- standard_attributes.each_with_index do |attribute, attribute_index| -%>
        assert_select "tr>td", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2
  <%- end -%>
  <%- datetime_attributes.each_with_index do |attribute, attribute_index| -%>
        assert_select "tr>td", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2
  <%- end -%>
<% end -%>
      end
<% references_attributes.each_with_index do |attribute, attribute_index| -%>
  <%- next if parent_model_tables.include?(attribute.name.to_s) -%>

      it "displays the <%= attribute.name %> belonging to <%= resource_table_name %>" do
        render
  <%- if webrat? -%>
        rendered.should have_selector("tr>td", :content => <%= attribute.name %>.to_s, :count => 2)
  <%- else -%>
        assert_select "tr>td", :text => <%= attribute.name %>.to_s, :count => 2
  <%- end -%>
      end
<% end -%>
<% references_attributes.each_with_index do |attribute, attribute_index| -%>
  <%- next unless parent_model_tables.include?(attribute.name.to_s) -%>

      it "does not display the <%= attribute.name %> belonging to <%= resource_table_name %>" do
        render
  <%- if webrat? -%>
        rendered.should have_selector("tr>td", :content => <%= attribute.name %>.to_s, :count => 0)
  <%- else -%>
        assert_select "tr>td", :text => <%= attribute.name %>.to_s, :count => 0
  <%- end -%>
      end
<% end -%>

      describe 'show <%= resource_table_name %> link' do
        it "renders a link to <%= ns_file_name %>_path" do
          render
<% [1,2].each do |model_index| -%>
  <%- if webrat? -%>
          rendered.should have_selector("td>a[href]:not([data-method])", :href => <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1)
  <%- else -%>
          assert_select "td>a[href=?]:not([data-method])", <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1
  <%- end -%>
<% end -%>
        end
      end

      describe 'edit <%= resource_table_name %> link' do
        context 'without update permissions' do
          it "renders a disabled link to edit_<%= ns_file_name %>_path" do
            render
<% [1,2].each do |model_index| -%>
  <%- if webrat? -%>
            rendered.should_not have_selector("td>a[href][disabled=disabled]", :href => edit_<%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1)
  <%- else -%>
            assert_select "td>a[href=?][disabled=disabled]", edit_<%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1
  <%- end -%>
<% end -%>
          end
        end
        context 'with update permissions' do
          it "renders a link to edit_<%= ns_file_name %>_path" do
            @ability.can :update, <%= local_class_name %>
            render
<% [1,2].each do |model_index| -%>
  <%- if webrat? -%>
            rendered.should have_selector("td>a[href]:not([disabled])", :href => edit_<%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1)
  <%- else -%>
            assert_select "td>a[href=?]:not([disabled])", edit_<%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1
  <%- end -%>
<% end -%>
          end
        end
      end

      describe 'destroy <%= resource_table_name %> link' do
        context 'without destroy permissions' do
          it "renders a disabled link to <%= ns_file_name %>_path" do
            render
<% [1,2].each do |model_index| -%>
  <%- if webrat? -%>
            rendered.should_not have_selector("td>a[href][data-method=delete][disabled=disabled]", :href => <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1)
  <%- else -%>
            assert_select "td>a[href=?][data-method=delete][disabled=disabled]", <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1
  <%- end -%>
<% end -%>
          end
        end
        context 'with destroy permissions' do
          it "renders a link to <%= ns_file_name %>_path" do
            @ability.can :destroy, <%= local_class_name %>
            render
<% [1,2].each do |model_index| -%>
  <%- if webrat? -%>
            rendered.should have_selector("td>a[href][data-method=delete]:not([disabled])", :href => <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1)
  <%- else -%>
            assert_select "td>a[href=?][data-method=delete]:not([disabled])", <%= t_helper.controller_show_route t_helper.resource_test_var(model_index) %>, :count => 1
  <%- end -%>
<% end -%>
          end
        end
      end
    end

    describe 'new <%= resource_table_name %> link' do
      context 'without create permissions' do
        it "does not render a link to new_<%= ns_file_name %>_path" do
          render
<% if webrat? -%>
          rendered.should_not have_selector("a[href=?]", :href => new_<%= t_helper.controller_show_route %>, :count => 1)
<% else -%>
          assert_select "a[href=?]", new_<%= t_helper.controller_show_route %>, :count => 0
<% end -%>
        end
      end
      context 'with create permissions' do
        it "renders a link to new_<%= ns_file_name %>_path" do
          @ability.can :create, <%= local_class_name %>
          render
<% if webrat? -%>
          rendered.should have_selector("a[href=?]", new_<%= t_helper.controller_show_route %>, :count => 1)
<% else -%>
          assert_select "a[href=?]", new_<%= t_helper.controller_show_route %>, :count => 1
<% end -%>
        end
      end
    end
  end

end