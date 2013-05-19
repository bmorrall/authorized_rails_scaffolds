module TestVarMacros

  # Variable to hold stubs of parent models
  def references_test_var(references_table)
    "@#{references_test_name(references_table)}"
  end

  def references_test_sym(references_table)
    ":#{references_test_name(references_table)}"
  end

  def references_test_name(references_table, var_number = nil)
    if parent_model_names.include? references_table
      parent_property = "parent_#{references_table}"
    else
      parent_property = "stub_#{references_table}"
    end
    parent_property = "#{parent_property}_#{var_number}" unless var_number.nil?
    parent_property
  end

  # Variable name stub resource is assigned to (i.e. @foo_bar)
  def resource_test_var(var_number = nil)
    "@#{resource_test_name(var_number)}"
  end

  # Symbol used to assign test resources (i.e. :foo_bar)
  def resource_test_sym(var_number = nil)
    ":#{resource_test_name(var_number)}"
  end

  # Generator for properties used for testing
  def resource_test_name(var_number = nil)
    resource_property = "test_#{resource_name}"
    resource_property = "#{resource_property}_#{var_number}" unless var_number.nil?
    resource_property
  end
  

end