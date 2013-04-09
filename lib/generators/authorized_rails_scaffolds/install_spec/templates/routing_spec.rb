require "spec_helper"

<% module_namespacing do -%>
<%-

t_helper = AuthorizedRailsScaffolds::RoutingSpecHelper.new(
  ns_table_name: ns_table_name
)

request_path = t_helper.request_path
extra_params = t_helper.extra_params

-%>
describe <%= controller_class_name %>Controller do
  describe "routing" do

<% unless options[:singleton] -%>
    it "routes to #index" do
      get("/<%= request_path %>").should route_to("<%= ns_table_name %>#index"<%= extra_params %>)
    end

<% end -%>
    it "routes to #new" do
      get("/<%= request_path %>/new").should route_to("<%= ns_table_name %>#new"<%= extra_params %>)
    end

    it "routes to #show" do
      get("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#show"<%= extra_params %>, :id => "1")
    end

    it "routes to #edit" do
      get("/<%= request_path %>/1/edit").should route_to("<%= ns_table_name %>#edit"<%= extra_params %>, :id => "1")
    end

    it "routes to #create" do
      post("/<%= request_path %>").should route_to("<%= ns_table_name %>#create"<%= extra_params %>)
    end

    it "routes to #update" do
      put("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#update"<%= extra_params %>, :id => "1")
    end

    it "routes to #destroy" do
      delete("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#destroy"<%= extra_params %>, :id => "1")
    end

  end
end
<% end -%>