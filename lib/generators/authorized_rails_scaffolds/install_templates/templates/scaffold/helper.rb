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

  def <%= resource_name %>_form_values(<%= resource_name %>)
    <%= t_helper.scoped_values_for_form resource_name %>
  end

end
<% end -%>
