require 'spec_helper'

<%-

local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name

output_attributes   = attributes.reject{|attribute| [:timestamp].include? attribute.type }
standard_attributes = attributes.reject{|attribute| [:time, :date, :datetime].include? attribute.type }
datetime_attributes = attributes.reject{|attribute| ![:time, :date, :datetime].include? attribute.type }

# Returns code that will generate attribute_value as an attribute_type
def factory_attribute_value(attribute_type, attribute_value)
  case attribute_type
  when :datetime
    "DateTime.parse(#{attribute_value})"
  when :time
    value_as_time = attribute_value.to_time.strftime('%T')
    "Time.parse(#{value_as_time.dump})"
  when :date
    value_as_date = attribute_value.to_time.strftime('%Y-%m-%d')
    "Date.parse(#{value_as_date.dump})"
  else
    attribute_value
  end
end

-%>
describe "<%= ns_table_name %>/new" do
  before(:each) do
    <%- AuthorizedRailsScaffolds::PARENT_MODELS.each do |model| -%>
    @<%= model.underscore %> = assign(:<%= model.underscore %>, FactoryGirl.build_stubbed(:<%= model.underscore %>))
    <%- end -%>
    assign(:<%= var_name %>, FactoryGirl.build(:<%= var_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= factory_attribute_value attribute.type, value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= !output_attributes.empty? ? "    ))\n  end" : "  end" %>

  it "renders new <%= var_name %> form" do
    render

<% if webrat? -%>
    rendered.should have_selector("form", :action => <%= table_name %>_path, :method => "post") do |form|
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
    assert_select "form[action=?][method=?]", <%= index_helper %>_path, "post" do
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
    rendered.should have_selector("form", :action => <%= table_name %>_path, :method => "post") do |form|
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
    assert_select "form[action=?][method=?]", <%= table_name %>_path, "post" do
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