require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::Helper.new(class_name, singular_table_name, file_name)

local_class_name = class_name.split('::')[-1] # Non-Namespaced class name
var_name = file_name # Non-namespaced variable name
plural_var_name = var_name.pluralize # Pluralized non-namespaced variable name

output_attributes   = attributes.reject{|attribute| [:timestamp].include? attribute.type }

-%>
describe "<%= ns_table_name %>/index" do
  before(:each) do
    <%- AuthorizedRailsScaffolds::PARENT_MODELS.each do |model| -%>
    @<%= model.underscore %> = assign(:<%= model.underscore %>, FactoryGirl.build_stubbed(:<%= model.underscore %>))
    <%- end -%>
<% [1,2].each_with_index do |id, model_index| -%>
    @<%= var_name %>_<%= model_index + 1 %> = FactoryGirl.build_stubbed(:<%= var_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
    )
<% end -%>
<% end -%>
    assign(:<%= plural_var_name %>, [
<% [1,2].each_with_index do |id, model_index| -%>
      @<%= var_name %>_<%= id %><%= model_index == 1 ? '' : ',' %>
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
      rendered.should have_selector(".page-header>h1", :content => <%= var_name.humanize.pluralize.dump %>, :count => 1)
<% else -%>
      assert_select ".page-header>h1", :text => <%= var_name.humanize.pluralize.dump %>, :count => 1
<% end -%>
    end
  end

  describe "<%= plural_var_name %> table" do
    it 'includes a row for each <%= var_name %>' do
      render
<% unless webrat? -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
      rendered.should have_selector("table>tbody>tr.<%= var_name %>_#{@<%= var_name %>_<%= model_index %>.id}", :count => 1)
<% else -%>
      assert_select "table>tbody>tr.<%= var_name %>_#{@<%= var_name %>_<%= model_index %>.id}", :count => 1
<% end -%>
<% end -%>
    end

    it "contains a list of <%= plural_var_name %>" do
      render
<% unless webrat? -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
      rendered.should have_selector("tr>td.id-column", :content => @<%= var_name %>_<%= model_index %>.id.to_s, :count => 1)
<% else -%>
      assert_select "tr>td.id-column", :text => @<%= var_name %>_<%= model_index %>.id.to_s, :count => 1
<% end -%>
<% end -%>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
<% if webrat? -%>
      rendered.should have_selector("tr>td", :content => <%= factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2)
<% else -%>
      assert_select "tr>td", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s, :count => 2
<% end -%>
<% end -%>
    end

    describe 'show <%= var_name %> link' do
      it "renders a link to <%= ns_file_name %>_path" do
        render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
        rendered.should have_selector("td>a[href]:not([data-method])", :href => <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1)
<% else -%>
        assert_select "td>a[href=?]:not([data-method])", <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1
<% end -%>
<% end -%>
      end
    end

    describe 'edit <%= var_name %> link' do
      context 'without update permissions' do
        it "renders a disabled link to edit_<%= ns_file_name %>_path" do
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should_not have_selector("td>a[href][disabled=disabled]", :href => edit_<%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1)
<% else -%>
          assert_select "td>a[href=?][disabled=disabled]", edit_<%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1
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
          rendered.should have_selector("td>a[href]:not([disabled])", :href => edit_<%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1)
<% else -%>
          assert_select "td>a[href=?]:not([disabled])", edit_<%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1
<% end -%>
<% end -%>
        end
      end
    end

    describe 'destroy <%= var_name %> link' do
      context 'without destroy permissions' do
        it "renders a disabled link to <%= ns_file_name %>_path" do
          render
<% [1,2].each do |model_index| -%>
<% if webrat? -%>
          rendered.should_not have_selector("td>a[href][data-method=delete][disabled=disabled]", :href => <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1)
<% else -%>
          assert_select "td>a[href=?][data-method=delete][disabled=disabled]", <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1
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
          rendered.should have_selector("td>a[href][data-method=delete]:not([disabled])", :href => <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1)
<% else -%>
          assert_select "td>a[href=?][data-method=delete]:not([disabled])", <%= t_helper.controller_show_route "@#{var_name}_#{model_index}" %>, :count => 1
<% end -%>
<% end -%>
        end
      end
    end
  end

  describe 'new <%= var_name %> link' do
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