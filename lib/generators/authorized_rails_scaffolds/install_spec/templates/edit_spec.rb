require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::Helper.new(class_name, singular_table_name, file_name)

local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name

output_attributes   = attributes.reject{|attribute| [:timestamp].include? attribute.type }
standard_attributes = attributes.reject{|attribute| [:time, :date, :datetime].include? attribute.type }
datetime_attributes = attributes.reject{|attribute| ![:time, :date, :datetime].include? attribute.type }

-%>
describe "<%= ns_table_name %>/edit" do
  before(:each) do
    <%- AuthorizedRailsScaffolds.parent_models.each do |model| -%>
    @<%= model.underscore %> = assign(:<%= model.underscore %>, FactoryGirl.build_stubbed(:<%= model.underscore %>))
    <%- end -%>
    @<%= var_name %> = assign(:<%= var_name %>, FactoryGirl.build_stubbed(:<%= var_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    ))\n" -%>
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
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%Y').dump %>, :count => 1
      end
      assert_select "select#<%= var_name %>_<%= attribute.name %>_2i[name=?]", "<%= var_name %>[<%= attribute.name %>(2i)]" do
        assert_select "option[selected=selected][value=?]", <%= DateTime.parse(attribute.default).strftime('%-m').dump %>, :text => <%= DateTime.parse(attribute.default).strftime('%B').dump %>, :count => 1
      end
      assert_select "select#<%= var_name %>_<%= attribute.name %>_3i[name=?]", "<%= var_name %>[<%= attribute.name %>(3i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%d').dump %>, :count => 1
      end
  <%- end -%>
  <%- if [:time, :datetime].include? attribute.type -%>
      assert_select "select#<%= var_name %>_<%= attribute.name %>_4i[name=?]", "<%= var_name %>[<%= attribute.name %>(4i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%H').dump %>, :count => 1
      end
      assert_select "select#<%= var_name %>_<%= attribute.name %>_5i[name=?]", "<%= var_name %>[<%= attribute.name %>(5i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%M').dump %>, :count => 1
      end
  <%- end -%>
<% end -%>
    end
<% end -%>
  end

<% end -%>
end
