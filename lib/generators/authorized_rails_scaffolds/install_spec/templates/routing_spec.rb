require "spec_helper"

<% module_namespacing do -%>
<%-

parts = ns_table_name.split('/')[0..-2] || []

AuthorizedRailsScaffolds::PARENT_MODELS.each_with_index do |model, model_index|
  parts << model.underscore.pluralize
  parts << model_index + 2
end

parts << ns_table_name.split('/')[-1]
request_path = parts.join('/')

extra_arguments = ''
if AuthorizedRailsScaffolds::PARENT_MODELS.any?
  AuthorizedRailsScaffolds::PARENT_MODELS.each_with_index do |model, model_index|
    extra_arguments += ", :#{model.underscore}_id => \"#{model_index + 2}\""
  end
end

-%>
describe <%= controller_class_name %>Controller do
  describe "routing" do

<% unless options[:singleton] -%>
    it "routes to #index" do
      get("/<%= request_path %>").should route_to("<%= ns_table_name %>#index"<%= extra_arguments %>)
    end

<% end -%>
    it "routes to #new" do
      get("/<%= request_path %>/new").should route_to("<%= ns_table_name %>#new"<%= extra_arguments %>)
    end

    it "routes to #show" do
      get("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#show"<%= extra_arguments %>, :id => "1")
    end

    it "routes to #edit" do
      get("/<%= request_path %>/1/edit").should route_to("<%= ns_table_name %>#edit"<%= extra_arguments %>, :id => "1")
    end

    it "routes to #create" do
      post("/<%= request_path %>").should route_to("<%= ns_table_name %>#create"<%= extra_arguments %>)
    end

    it "routes to #update" do
      put("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#update"<%= extra_arguments %>, :id => "1")
    end

    it "routes to #destroy" do
      delete("/<%= request_path %>/1").should route_to("<%= ns_table_name %>#destroy"<%= extra_arguments %>, :id => "1")
    end

  end
end
<% end -%>