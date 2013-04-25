require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldGeneratorViewHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

local_class_name = t_helper.local_class_name # Non-Namespaced class name
var_name = t_helper.var_name # Non-namespaced variable name

controller_directory = t_helper.controller_directory
parent_model_tables = t_helper.parent_model_tables

output_attributes = t_helper.output_attributes
standard_attributes = t_helper.standard_attributes
datetime_attributes = t_helper.datetime_attributes

-%>
describe "<%= controller_directory %>/edit" do

<% parent_model_tables.each_with_index do |parent_model, index| -%>
<%- if index == 0 -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>) }
<%- else -%>
  let(:<%= parent_model %>) { FactoryGirl.build_stubbed(:<%= parent_model %>, :<%= parent_model_tables[index - 1] %> => <%= parent_model_tables[index - 1] %>) }
<%- end -%>
<%- end -%>
  let(:<%= var_name %>) do
    FactoryGirl.build_stubbed(:<%= var_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <% if attribute.type == :references && parent_model_tables.include?(attribute.name) %><%= attribute.name %><% else %><%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><% end %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    )\n" -%>
  end

  context do # Within default nesting
    before(:each) do
      # Add Properties for default view scope
<%- parent_model_tables.each do |parent_model| -%>
      assign(:<%= parent_model %>, @<%= parent_model %> = <%= parent_model %>)
<%- end -%>
      assign(:<%= var_name %>, @<%= var_name %> = <%= var_name %>)
    end

    it "renders the edit <%= var_name %> form" do
      render

<% if webrat? -%>
      rendered.should have_selector("form", :action => <%= t_helper.controller_show_route "@#{var_name}" %>, :method => "post") do |form|
<% for attribute in standard_attributes -%>
  <%- if attribute.type == :references -%>
        form.should have_selector("select#<%= var_name %>_<%= attribute.name %>_id", :name => "<%= var_name %>[<%= attribute.name %>_id]")
  <%- else -%>
        form.should have_selector("<%= attribute.input_type -%>#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
  <%- end -%>
<% end -%>
      end
<% else -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", <%= t_helper.controller_show_route "@#{var_name}" %>, "post" do
<% for attribute in standard_attributes -%>
  <%- if attribute.type == :references -%>
        assert_select "select#<%= var_name %>_<%= attribute.name %>_id[name=?]", "<%= var_name %>[<%= attribute.name %>_id]"
  <%- else -%>
        assert_select "<%= attribute.input_type -%>#<%= var_name %>_<%= attribute.name %>[name=?]", "<%= var_name %>[<%= attribute.name %>]"
  <%- end -%>
<% end -%>
      end
<% end -%>
    end

<% if datetime_attributes.any? -%>
    it "renders all date/time form elements" do
      render

<% if webrat? -%>
      rendered.should have_selector("form", :action => <%= t_helper.controller_show_route "@#{var_name}" %>, :method => "post") do |form|
<% for attribute in datetime_attributes -%>
  <%- if [:date, :datetime].include? attribute.type -%>
      form.should have_selector("select#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
      form.should have_selector("select#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
      form.should have_selector("select#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
  <%- end -%>
  <%- if [:time, :datetime].include? attribute.type -%>
      form.should have_selector("select#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
      form.should have_selector("select#<%= var_name %>_<%= attribute.name %>", :name => "<%= var_name %>[<%= attribute.name %>]")
  <%- end -%>
<% end -%>
      end
<% else -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", <%= t_helper.controller_show_route "@#{var_name}" %>, "post" do
<% for attribute in datetime_attributes -%>
        # <%= attribute.name %> values
  <%- if [:date, :datetime].include? attribute.type -%>
        assert_select "select#<%= var_name %>_<%= attribute.name %>_1i[name=?]", "<%= var_name %>[<%= attribute.name %>(1i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_year_value attribute.default %>", :count => 1
        end
        assert_select "select#<%= var_name %>_<%= attribute.name %>_2i[name=?]", "<%= var_name %>[<%= attribute.name %>(2i)]" do
          assert_select "option[selected=selected][value=?]", "<%= t_helper.date_select_month_value attribute.default %>", :text => "<%= t_helper.date_select_month_text attribute.default %>", :count => 1
        end
        assert_select "select#<%= var_name %>_<%= attribute.name %>_3i[name=?]", "<%= var_name %>[<%= attribute.name %>(3i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_day_value attribute.default %>", :count => 1
        end
  <%- end -%>
  <%- if [:time, :datetime].include? attribute.type -%>
        assert_select "select#<%= var_name %>_<%= attribute.name %>_4i[name=?]", "<%= var_name %>[<%= attribute.name %>(4i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_hour_value attribute.default %>", :count => 1
        end
        assert_select "select#<%= var_name %>_<%= attribute.name %>_5i[name=?]", "<%= var_name %>[<%= attribute.name %>(5i)]" do
          assert_select "option[selected=selected]", :text => "<%= t_helper.date_select_minute_value attribute.default %>", :count => 1
        end
  <%- end -%>
<% end -%>
      end
<% end -%>
    end

<% end -%>
  end
end
