require 'spec_helper'

<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldViewHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

resource_var = t_helper.resource_var
resource_symbol = t_helper.resource_symbol
resource_name = t_helper.resource_name
resource_test_name = t_helper.resource_test_name

resource_directory = t_helper.resource_directory
parent_model_names = t_helper.parent_model_names

output_attributes = t_helper.output_attributes
datetime_attributes = t_helper.datetime_attributes
references_attributes = t_helper.references_attributes
standard_attributes = t_helper.standard_attributes

-%>
describe "<%= resource_directory %>/show" do

<% parent_model_names.each_with_index do |parent_model, index| -%>
<%- if index == 0 -%>
  let(<%= t_helper.references_test_sym(parent_model) %>) { FactoryGirl.build_stubbed(:<%= parent_model %>) }
<%- else -%>
  let(<%= t_helper.references_test_sym(parent_model) %>) { FactoryGirl.build_stubbed(:<%= parent_model %>, :<%= parent_model_names[index - 1] %> => <%= parent_model_names[index - 1] %>) }
<%- end -%>
<%- end -%>
<% references_attributes.each do |parent_attribute| -%>
  <%- next if parent_model_names.include? parent_attribute.name -%>
  let(<%= t_helper.references_test_sym(parent_attribute.name) %>) { FactoryGirl.build_stubbed(:<%= parent_attribute.name %>) }
<% end -%>
  let(<%= t_helper.resource_test_sym %>) do
    FactoryGirl.build_stubbed(:<%= t_helper.resource_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <% if attribute.type == :references %><%= t_helper.references_test_name(attribute.name) %><% else %><%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><% end %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    )\n" -%>
  end

  before(:each) do
    # Stub ability for testing
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  context<% if parent_model_names.any? %> "within <%= parent_model_names.join('/') %> nesting"<% end %> do<%- unless parent_model_names.any? -%> # Within default nesting<% end %>
    before(:each) do
      # Add Properties for view scope
<%- parent_model_names.each do |parent_model| -%>
      assign(<%= t_helper.parent_sym(parent_model) %>, <%= t_helper.references_test_name(parent_model) %>)
<%- end -%>
      assign(<%= resource_symbol %>, <%= t_helper.resource_test_name %>)
    end

    it "renders attributes in a <dl> as a <dt> and <dd> pair" do
      render
<% unless webrat? -%>
      # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<%- for attribute in standard_attributes -%>
  <%- if webrat? -%>
      rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
      rendered.should have_selector("dl>dd", :content => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s)
  <%- else -%>
      assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
      assert_select "dl>dd", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s
  <%- end -%>
<%- end -%>
<%- for attribute in datetime_attributes -%>
  <%- if webrat? -%>
      rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>)
      rendered.should have_selector("dl>dd", :content => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s)
  <%- else -%>
      assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
      assert_select "dl>dd", :text => <%= t_helper.factory_attribute_string attribute.type, value_for(attribute) %>.to_s
  <%- end -%>
<%- end -%>
    end
<% for attribute in references_attributes -%>

    context "with a <%= attribute.name %> reference" do
      before(:each) do
        <%= resource_test_name %>.<%= attribute.name %> = FactoryGirl.build_stubbed(:<%= attribute.name %>)
      end
      context 'without read <%= attribute.name.classify %> permissions' do
        it "should not a render link to <%= attribute.name %>" do
          render
<% if webrat? -%>
          rendered.should have_selector("dl>dt", :content => <%= "#{attribute.human_name}:".dump %>, :count => 0)
          rendered.should have_selector("dl>dd>a[href]", :href => <%= t_helper.references_show_route(attribute.name) %>, :count => 0)
<% else -%>
          assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>, :count => 0
          assert_select "dl>dd>a[href=?]", <%= t_helper.references_show_route(attribute.name) %>, :count => 0
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
          rendered.should have_selector("dl>dd>a[href]", :href => <%= t_helper.references_show_route(attribute.name) %>, :count => 1)
<% else -%>
          assert_select "dl>dt", :text => <%= "#{attribute.human_name}:".dump %>
          assert_select "dl>dd>a[href=?]", <%= t_helper.references_show_route(attribute.name) %>, :count => 1
<% end -%>
        end
      end
    end
<% end -%>
  end

end