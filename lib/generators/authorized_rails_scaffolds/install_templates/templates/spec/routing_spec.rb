require "spec_helper"

<% module_namespacing do -%>
<%-

#
# Available properties:
# 
#   class_name
#   controller_class_name
#   singular_table_name
#   file_name
#   attributes
#

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldRoutingHelper.new(
  :class_name => class_name,
  :controller_class_name => controller_class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

# request_path = t_helper.request_path
resource_directory = t_helper.resource_directory
example_controller_path = t_helper.example_controller_path
example_controller_path_extra_params = t_helper.example_controller_path_extra_params

-%>
describe <%= t_helper.controller_class_name %> do
  describe "routing" do

<% unless options[:singleton] -%>
    it "routes to #index" do
      get("<%= example_controller_path %>").should route_to("<%= resource_directory %>#index"<%= example_controller_path_extra_params %>)
    end

<% end -%>
    it "routes to #new" do
      get("<%= example_controller_path %>/new").should route_to("<%= resource_directory %>#new"<%= example_controller_path_extra_params %>)
    end

    it "routes to #show" do
      get("<%= example_controller_path %>/1").should route_to("<%= resource_directory %>#show"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #edit" do
      get("<%= example_controller_path %>/1/edit").should route_to("<%= resource_directory %>#edit"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #create" do
      post("<%= example_controller_path %>").should route_to("<%= resource_directory %>#create"<%= example_controller_path_extra_params %>)
    end

    it "routes to #update" do
      put("<%= example_controller_path %>/1").should route_to("<%= resource_directory %>#update"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #destroy" do
      delete("<%= example_controller_path %>/1").should route_to("<%= resource_directory %>#destroy"<%= example_controller_path_extra_params %>, :id => "1")
    end

  end
end
<% end -%>