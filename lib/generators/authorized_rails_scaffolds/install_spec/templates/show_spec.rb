require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:timestamp].index(attribute.type) } -%>
describe "<%= ns_table_name %>/show" do
  before(:each) do
    @<%= file_name %> = FactoryGirl.build_stubbed(:<%= file_name %><%= output_attributes.empty? ? ')' : ',' %>
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
<% if !output_attributes.empty? -%>
    )
<% end -%>
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in a <dl> as a <dt> and <dd> pair" do
    render
<% unless webrat? -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% for attribute in attributes -%>
<%-
if attribute.type == :datetime
  date_time_value = DateTime.parse(value_for(attribute))
  attribute_value = I18n.l(date_time_value, :format => :long).dump
elsif attribute.type == :time
  time_value = Time.parse(value_for(attribute))
  attribute_value = I18n.l(time_value, :format => :short).dump
elsif attribute.type == :date
  date_value = Date.parse(value_for(attribute))
  attribute_value = I18n.l(date_value).dump
else
  attribute_value = value_for(attribute)
end
-%>
<% if webrat? -%>
    rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
    rendered.should have_selector("dl>dd", :content => <%= attribute_value %>.to_s)
<% else -%>
    assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
    assert_select "dl>dd", :text => <%= attribute_value %>.to_s
<% end -%>
<% end -%>
  end
end