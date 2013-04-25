require "spec_helper"

<% module_namespacing do -%>
<%-

t_helper = AuthorizedRailsScaffolds::RSpecScaffoldGeneratorHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name,
  :attributes => attributes
)

# request_path = t_helper.request_path
controller_directory = t_helper.controller_directory
example_controller_path = t_helper.example_controller_path
example_controller_path_extra_params = t_helper.example_controller_path_extra_params

-%>
describe <%= controller_class_name %>Controller do
  describe "routing" do

<% unless options[:singleton] -%>
    it "routes to #index" do
      get("<%= example_controller_path %>").should route_to("<%= controller_directory %>#index"<%= example_controller_path_extra_params %>)
    end

<% end -%>
    it "routes to #new" do
      get("<%= example_controller_path %>/new").should route_to("<%= controller_directory %>#new"<%= example_controller_path_extra_params %>)
    end

    it "routes to #show" do
      get("<%= example_controller_path %>/1").should route_to("<%= controller_directory %>#show"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #edit" do
      get("<%= example_controller_path %>/1/edit").should route_to("<%= controller_directory %>#edit"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #create" do
      post("<%= example_controller_path %>").should route_to("<%= controller_directory %>#create"<%= example_controller_path_extra_params %>)
    end

    it "routes to #update" do
      put("<%= example_controller_path %>/1").should route_to("<%= controller_directory %>#update"<%= example_controller_path_extra_params %>, :id => "1")
    end

    it "routes to #destroy" do
      delete("<%= example_controller_path %>/1").should route_to("<%= controller_directory %>#destroy"<%= example_controller_path_extra_params %>, :id => "1")
    end

  end
end
<% end -%>