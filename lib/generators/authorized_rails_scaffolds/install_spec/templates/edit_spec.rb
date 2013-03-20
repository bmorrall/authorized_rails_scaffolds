require 'spec_helper'

<% local_class_name = class_name.split('::')[-1] -%>
<% output_attributes = attributes.reject{|attribute| [:timestamp].index(attribute.type) } -%>
<% standard_attributes = output_attributes.reject{|attribute| [:time, :date, :datetime].index(attribute.type) } -%>
<% date_attributes = output_attributes.reject{|attribute| ![:time, :date, :datetime].index(attribute.type) } -%>
describe "<%= ns_table_name %>/edit" do
  before(:each) do
    @<%= file_name %> = assign(:<%= file_name %>, FactoryGirl.build_stubbed(:<%= file_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
<%-
attribute_prefix = ''
attribute_suffix = ')'
if attribute.type == :datetime
  attribute_value = value_for(attribute)
  attribute_prefix = 'DateTime.parse('
elsif attribute.type == :time
  attribute_value = value_for(attribute).to_time.strftime('%T').dump
  attribute_prefix = 'Time.parse('
elsif attribute.type == :date
  attribute_value = value_for(attribute)
  attribute_prefix = 'Date.parse('
else
  attribute_value = value_for(attribute)
  attribute_suffix = ''
end
-%>
      :<%= attribute.name %> => <%= attribute_prefix %><%= attribute_value %><%= attribute_suffix %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    ))\n" -%>
  end

  it "renders the edit <%= file_name %> form" do
    render

<% if webrat? -%>
    rendered.should have_selector("form", :action => <%= ns_file_name %>_path(@<%= file_name %>), :method => "post") do |form|
<% for attribute in standard_attributes -%>
    form.should have_selector("<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
<% end -%>
    end
<% else -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", <%= ns_file_name %>_path(@<%= file_name %>), "post" do
<% for attribute in standard_attributes -%>
      assert_select "<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>[name=?]", "<%= file_name %>[<%= attribute.name %>]"
<% end -%>
    end
<% end -%>
  end

<% if date_attributes.any? -%>
  it "renders all date/time form elements" do
    render

<% if webrat? -%>
    rendered.should have_selector("form", :action => <%= ns_file_name %>_path(@<%= file_name %>), :method => "post") do |form|
<% for attribute in date_attributes -%>
  <%- if [:date, :datetime].include? attribute.type -%>
    form.should have_selector("select#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
    form.should have_selector("select#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
    form.should have_selector("select#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
  <%- end -%>
  <%- if [:time, :datetime].include? attribute.type -%>
    form.should have_selector("select#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
    form.should have_selector("select#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
  <%- end -%>
<% end -%>
    end
<% else -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", <%= ns_file_name %>_path(@<%= file_name %>), "post" do
<% for attribute in date_attributes -%>
  <%- if [:date, :datetime].include? attribute.type -%>
      assert_select "select#<%= file_name %>_<%= attribute.name %>_1i[name=?]", "<%= file_name %>[<%= attribute.name %>(1i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%Y').dump %>, :count => 1
      end
      assert_select "select#<%= file_name %>_<%= attribute.name %>_2i[name=?]", "<%= file_name %>[<%= attribute.name %>(2i)]" do
        assert_select "option[selected=selected][value=?]", <%= DateTime.parse(attribute.default).strftime('%-m').dump %>, :text => <%= DateTime.parse(attribute.default).strftime('%B').dump %>, :count => 1
      end
      assert_select "select#<%= file_name %>_<%= attribute.name %>_3i[name=?]", "<%= file_name %>[<%= attribute.name %>(3i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%d').dump %>, :count => 1
      end
  <%- end -%>
  <%- if [:time, :datetime].include? attribute.type -%>
      assert_select "select#<%= file_name %>_<%= attribute.name %>_4i[name=?]", "<%= file_name %>[<%= attribute.name %>(4i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%H').dump %>, :count => 1
      end
      assert_select "select#<%= file_name %>_<%= attribute.name %>_5i[name=?]", "<%= file_name %>[<%= attribute.name %>(5i)]" do
        assert_select "option[selected=selected]", :text => <%= DateTime.parse(attribute.default).strftime('%M').dump %>, :count => 1
      end
  <%- end -%>
<% end -%>
    end
<% end -%>
  end

<% end -%>
end
