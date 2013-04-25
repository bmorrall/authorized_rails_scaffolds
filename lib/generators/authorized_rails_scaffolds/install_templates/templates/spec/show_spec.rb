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

output_attributes = t_helper.output_attributes
references_attributes = t_helper.references_attributes

-%>
describe "<%= ns_table_name %>/show" do
  before(:each) do
<%- AuthorizedRailsScaffolds.config.parent_models.each do |model| -%>
    @<%= model.underscore %> = FactoryGirl.build_stubbed(:<%= model.underscore %>)
<%- end -%>
    @<%= var_name %> = FactoryGirl.build_stubbed(:<%= var_name %><%= output_attributes.empty? ? ')' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= t_helper.factory_attribute_value attribute.type, value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
    )
<% end -%>
  end

  context do # Within default nesting
    before(:each) do
      # Add Properties for default view scope
<%- AuthorizedRailsScaffolds.config.parent_models.each do |model| -%>
      assign(:<%= model.underscore %>, @<%= model.underscore %>)
<%- end -%>
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