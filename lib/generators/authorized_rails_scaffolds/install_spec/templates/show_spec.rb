require 'spec_helper'

<%-

local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name

output_attributes   = attributes.reject{|attribute| [:timestamp, :references].include? attribute.type }
references_attributes = attributes.reject{|attribute| ![:references].include? attribute.type }

path_prefix = ns_file_name[0..-(file_name.length+1)]

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

# Returns the expected output string of attribute_value if it is an attribute_type
def factory_attribute_string(attribute_type, attribute_value)
  case attribute_type
  when :datetime
    attribute_value_as_date = DateTime.parse(attribute_value)
    I18n.l(attribute_value_as_date, :format => :long).dump
  when :time
    attribute_value_as_time = Time.parse(attribute_value)
    I18n.l(attribute_value_as_time, :format => :short).dump
  when :date
    attribute_value_as_date = Date.parse(attribute_value)
    I18n.l(attribute_value_as_date).dump
  else
    attribute_value
  end
end

-%>
describe "<%= ns_table_name %>/show" do
  before(:each) do
    <%- AuthorizedRailsScaffolds::PARENT_MODELS.each do |model| -%>
    @<%= model.underscore %> = assign(:<%= model.underscore %>, FactoryGirl.build_stubbed(:<%= model.underscore %>))
    <%- end -%>
    @<%= var_name %> = FactoryGirl.build_stubbed(:<%= var_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= factory_attribute_value attribute.type, value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
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
<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
    rendered.should have_selector("dl>dd", :content => <%= factory_attribute_string attribute.type, value_for(attribute) %>.to_s)
<% else -%>
    assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
    assert_select "dl>dd", :text => <%= factory_attribute_string attribute.type, value_for(attribute) %>.to_s
<% end -%>
<% end -%>
  end

<% for attribute in references_attributes -%>
  context "with a <%= attribute.name %> reference" do
    before(:each) do
      @<%= var_name %>.<%= attribute.name %> = FactoryGirl.build_stubbed(:<%= attribute.name %>)
    end
    context 'without read <%= attribute.name.classify %> permissions' do
      it "should not a render link to <%= attribute.name %>" do
        render
<% if webrat? -%>
        rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>, :count => 0)
        rendered.should have_selector("dl>dd>a[href]", :href => <%= path_prefix %><%= attribute.name %>_path(@<%= var_name %>.<%= attribute.name %>), :count => 0)
<% else -%>
        assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>, :count => 0
        assert_select "dl>dd>a[href=?]", <%= path_prefix %><%= attribute.name %>_path(@<%= var_name %>.<%= attribute.name %>), :count => 0
<% end -%>
      end
    end
    context 'with read <%= attribute.name.classify %> permissions' do
      before(:each) do
        @ability.can :read, <%= attribute.name.classify %>
      end
      it "renders a namespaced link to <%= attribute.name %>" do
        render
<% if webrat? -%>
        rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
        rendered.should have_selector("dl>dd>a[href]", :href => <%= path_prefix %><%= attribute.name %>_path(@<%= var_name %>.<%= attribute.name %>), :count => 1)
<% else -%>
        assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
        assert_select "dl>dd>a[href=?]", <%= path_prefix %><%= attribute.name %>_path(@<%= var_name %>.<%= attribute.name %>), :count => 1
<% end -%>
      end
    end
  end

<% end -%>
end