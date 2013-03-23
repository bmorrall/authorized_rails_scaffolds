require 'spec_helper'

<% module_namespacing do -%>
describe <%= class_name %> do
<%- attributes.each do |attribute| -%>
  <%- unless attribute.type == :references -%>
  it { should allow_mass_assignment_of(:<%= attribute.name %>)}
  <%- end -%>
<%- end -%>
<%- attributes.each_with_index do |attribute, attribute_index| -%>

  # <%= attribute.name %>:<%= attribute.type %>
  <%- if attribute_index == 0 -%>
  it { should validate_presence_of(:<%= attributes[0].name %>) }
  <%- end -%>
  <%- if attribute.type == :references -%>
  it { should belong_to(:<%= attribute.name %>) }
  <%- elsif attribute.type == :boolean -%>
  it { should allow_value(true).for(:<%= attribute.name %>) }
  it { should allow_value(false).for(:<%= attribute.name %>) }
  <%- elsif [:double, :decimal].include? attribute.type -%>
  it { should validate_numericality_of(:<%= attribute.name %>) }
  <%- elsif attribute.type == :integer -%>
  it { should validate_numericality_of(:<%= attribute.name %>).only_integer }
  <%- end -%>
<%- end -%>
end
<% end -%>
