require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldViewHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

resource_symbol = t_helper.resource_symbol
resource_test_var = t_helper.resource_test_var
resource_table_name = t_helper.resource_table_name

resource_directory = t_helper.resource_directory
parent_model_tables = t_helper.parent_model_tables

output_attributes = t_helper.output_attributes
datetime_attributes = t_helper.datetime_attributes
references_attributes = t_helper.references_attributes
standard_attributes = t_helper.standard_attributes

-%>
describe "<%= resource_directory %>/new" do

<% parent_model_tables.each_with_index do |parent_model, index| -%>
<%- if index == 0 -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>) }
<%- else -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>, :<%= parent_model_tables[index - 1] %> => <%= parent_model_tables[index - 1] %>) }
<%- end -%>
<%- end -%>
  let(:<%= t_helper.resource_table_name %>) do
    FactoryGirl.build(:<%= t_helper.resource_table_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <% if attribute.type == :references && parent_model_tables.include?(attribute.name) %><%= attribute.name %><% else %><%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><% end %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    )\n" -%>
  end

  context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
    before(:each) do
      # Add Properties for view scope
<%- parent_model_tables.each do |parent_model| -%>
      assign(:<%= parent_model %>, @<%= parent_model %> = <%= parent_model %>)
<%- end -%>
      assign(<%= resource_symbol %>, <%= resource_test_var %> = <%= resource_table_name %>)
    end

    it "renders new <%= resource_table_name %> form" do
      render

<% if webrat? -%>
      rendered.should have_selector("form", :action => <%= t_helper.controller_index_path %>, :method => "post") do |form|
<% for attribute in standard_attributes -%>
        form.should have_selector("<%= attribute.input_type -%>#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
<% end -%>
<% for attribute in references_attributes -%>
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>_id", :name => "<%= resource_table_name %>[<%= attribute.name %>_id]")
<% end -%>
      end
<% else -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", <%= t_helper.controller_index_path %>, "post" do
<% for attribute in standard_attributes -%>
        assert_select "<%= attribute.input_type -%>#<%= resource_table_name %>_<%= attribute.name %>[name=?]", "<%= resource_table_name %>[<%= attribute.name %>]"
<% end -%>
<% for attribute in references_attributes -%>
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_id[name=?]", "<%= resource_table_name %>[<%= attribute.name %>_id]"
<% end -%>
      end
<% end -%>
    end
<% if datetime_attributes.any? -%>

    it "renders all date/time form elements" do
      render

<% if webrat? -%>
      rendered.should have_selector("form", :action => <%= t_helper.controller_index_path %>, :method => "post") do |form|
  <%- for attribute in datetime_attributes -%>
    <%- if [:date, :datetime].include? attribute.type -%>
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
    <%- end -%>
    <%- if [:time, :datetime].include? attribute.type -%>
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
        form.should have_selector("select#<%= resource_table_name %>_<%= attribute.name %>", :name => "<%= resource_table_name %>[<%= attribute.name %>]")
    <%- end -%>
  <% end -%>
      end
<% else -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", <%= t_helper.controller_index_path %>, "post" do
  <%- for attribute in datetime_attributes -%>
        # <%= attribute.name %> values
    <%- if [:date, :datetime].include? attribute.type -%>
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_1i[name=?]", "<%= resource_table_name %>[<%= attribute.name %>(1i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_year_value attribute.default %>", :count => 1
        end
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_2i[name=?]", "<%= resource_table_name %>[<%= attribute.name %>(2i)]" do
          assert_select "option[selected=selected][value=?]", "<%= t_helper.date_select_month_value attribute.default %>", :text => "<%= t_helper.date_select_month_text attribute.default %>", :count => 1
        end
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_3i[name=?]", "<%= resource_table_name %>[<%= attribute.name %>(3i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_day_value attribute.default %>", :count => 1
        end
    <%- end -%>
    <%- if [:time, :datetime].include? attribute.type -%>
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_4i[name=?]", "<%= resource_table_name %>[<%= attribute.name %>(4i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_hour_value attribute.default %>", :count => 1
        end
        assert_select "select#<%= resource_table_name %>_<%= attribute.name %>_5i[name=?]", "<%= resource_table_name %>[<%= attribute.name %>(5i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_minute_value attribute.default %>", :count => 1
        end
    <%- end -%>
  <%- end -%>
      end
<% end -%>
    end
<% end -%>
  end
end