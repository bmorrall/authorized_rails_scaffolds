require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldViewHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

local_class_name = t_helper.local_class_name # Non-Namespaced class name
var_name = t_helper.var_name # Non-namespaced variable name

resource_directory = t_helper.resource_directory
parent_model_tables = t_helper.parent_model_tables

output_attributes = t_helper.output_attributes
references_attributes = t_helper.references_attributes

-%>
describe "<%= resource_directory %>/show" do

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

  context <% if parent_model_tables.any? %>"within <%= parent_model_tables.join('/') %> nesting"<% end %> do<%- unless parent_model_tables.any? -%> # Within default nesting<% end %>
    before(:each) do
      # Add Properties for view scope
<%- parent_model_tables.each do |parent_model| -%>
      assign(:<%= parent_model %>, @<%= parent_model %> = <%= parent_model %>)
<%- end -%>
      assign(:<%= var_name %>, @<%= var_name %> = <%= var_name %>)

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
  <%- if webrat? -%>
      rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
      rendered.should have_selector("dl>dd", :content => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s)
  <%- else -%>
      assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
      assert_select "dl>dd", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s
  <%- end -%>
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
          rendered.should have_selector("dl>dd>a[href]", :href => <%= t_helper.references_show_route attribute.name %>, :count => 0)
<% else -%>
          assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>, :count => 0
          assert_select "dl>dd>a[href=?]", <%= t_helper.references_show_route attribute.name %>, :count => 0
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
          rendered.should have_selector("dl>dd>a[href]", :href => <%= t_helper.references_show_route attribute.name %>, :count => 1)
<% else -%>
          assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
          assert_select "dl>dd>a[href=?]", <%= t_helper.references_show_route attribute.name %>, :count => 1
<% end -%>
        end
      end
    end
<% end -%>
  end

end