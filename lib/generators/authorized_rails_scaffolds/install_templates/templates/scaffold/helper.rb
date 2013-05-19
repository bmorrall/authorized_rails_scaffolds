<% module_namespacing do -%>
<%-

t_helper = AuthorizedRailsScaffolds::RailsHelperHelper.new(
  :class_name => class_name,
  :singular_table_name => singular_table_name,
  :file_name => file_name
)

resource_name = t_helper.resource_name

-%>
module <%= class_name %>Helper

  # Returns the form arguments required to create or update the <%= resource_name %>
  def <%= resource_name %>_form_values(<%= resource_name %>)
    <%- if t_helper.shallow_routes? -%>
    <%= resource_name %>.persisted? ? <%= t_helper.scoped_values_for_form resource_name, true %> : <%= t_helper.scoped_values_for_form resource_name, false %>
    <%- else -%>
    <%= t_helper.scoped_values_for_form resource_name %>
    <%- end -%>
  end

end
<% end -%>
