require 'spec_helper'

<%- local_class_name = class_name.split('::')[-1] -%>
<%- output_attributes = attributes.reject{|attribute| [:timestamp].index(attribute.type) } -%>
describe "<%= ns_table_name %>/index" do
  before(:each) do
<% [1,2].each_with_index do |id, model_index| -%>
    @<%= file_name %>_<%= model_index + 1 %> = FactoryGirl.build_stubbed(:<%= file_name %><%= output_attributes.empty? ? ')' : ',' %>
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
<% end -%>
    assign(:<%= file_name.pluralize %>, [
<% [1,2].each_with_index do |id, model_index| -%>
      @<%= file_name %>_<%= id %><%= model_index == 1 ? '' : ',' %>
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
      rendered.should have_selector(".page-header>h1", :content => <%= file_name.humanize.pluralize.dump %>, :count => 1)
<% else -%>
      assert_select ".page-header>h1", :text => <%= file_name.humanize.pluralize.dump %>, :count => 1
<% end -%>
    end
  end

  describe "<%= file_name.pluralize %> table" do
    it 'includes a row for each <%= file_name %>' do
      render
<% unless webrat? -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
      rendered.should have_selector("table>tbody>tr.<%= file_name %>_#{@<%= file_name %>_<%= model_index %>.id}", :count => 1)
<% else -%>
      assert_select "table>tbody>tr.<%= file_name %>_#{@<%= file_name %>_<%= model_index %>.id}", :count => 1
<% end -%>
<% end -%>
    end

    it "contains a list of <%= file_name.pluralize %>" do
      render
<% unless webrat? -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
      rendered.should have_selector("tr>td.id-column", :content => @<%= file_name %>_<%= model_index %>.id.to_s, :count => 1)
<% else -%>
      assert_select "tr>td.id-column", :text => @<%= file_name %>_<%= model_index %>.id.to_s, :count => 1
<% end -%>
<% end -%>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
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
      rendered.should have_selector("tr>td<% if attribute_index == 0 %>>a<% end %>", :content => <%= attribute_value %>.to_s, :count => 2)
<% else -%>
      assert_select "tr>td<% if attribute_index == 0 %>>a<% end %>", :text => <%= attribute_value %>.to_s, :count => 2
<% end -%>
<% end -%>
    end

    describe 'edit <%= file_name %> link' do
      context 'without update permissions' do
        it "renders a disabled link to edit_<%= ns_file_name %>_path" do
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should_not have_selector("td>a[href][disabled=disabled]", :href => edit_<%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1)
<% else -%>
          assert_select "td>a[href=?][disabled=disabled]", edit_<%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1
<% end -%>
<% end -%>
        end
      end
      context 'with update permissions' do
        it "renders a link to edit_<%= ns_file_name %>_path" do
          @ability.can :update, <%= local_class_name %>
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should have_selector("td>a[href]:not([disabled])", :href => edit_<%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1)
<% else -%>
          assert_select "td>a[href=?]:not([disabled])", edit_<%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1
<% end -%>
<% end -%>
        end
      end
    end

    describe 'destroy <%= file_name %> link' do
      context 'without destroy permissions' do
        it "renders a disabled link to <%= ns_file_name %>_path" do
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should_not have_selector("td>a[href][data-method=delete][disabled=disabled]", :href => <%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1)
<% else -%>
          assert_select "td>a[href=?][data-method=delete][disabled=disabled]", <%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1
<% end -%>
<% end -%>
        end
      end
      context 'with destroy permissions' do
        it "renders a link to <%= ns_file_name %>_path" do
          @ability.can :destroy, <%= local_class_name %>
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should have_selector("td>a[href][data-method=delete]:not([disabled])", :href => <%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1)
<% else -%>
          assert_select "td>a[href=?][data-method=delete]:not([disabled])", <%= ns_file_name %>_path(@<%= file_name %>_<%= model_index %>), :count => 1
<% end -%>
<% end -%>
        end
      end
    end
  end

  describe 'new <%= file_name %> link' do
    context 'without create permissions' do
      it "does not render a link to new_<%= ns_file_name %>_path" do
        render
<% if webrat? -%>
        rendered.should_not have_selector("a[href=?]", :href => new_<%= ns_file_name %>_path, :count => 1)
<% else -%>
        assert_select "a[href=?]", new_<%= ns_file_name %>_path, :count => 0
<% end -%>
      end
    end
    context 'with create permissions' do
      it "renders a link to new_<%= ns_file_name %>_path" do
        @ability.can :create, <%= local_class_name %>
        render
<% if webrat? -%>
        rendered.should have_selector("a[href=?]", new_<%= ns_file_name %>_path, :count => 1)
<% else -%>
        assert_select "a[href=?]", new_<%= ns_file_name %>_path, :count => 1
<% end -%>
      end
    end
  end

end