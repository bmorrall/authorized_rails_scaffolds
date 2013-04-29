module TestVarMacros

  # Variable to hold stubs of parent models
  def parent_test_var(parent_table)
    "@#{parent_test_property(parent_table)}"
  end

  def parent_test_sym(parent_table)
    ":#{parent_test_property(parent_table)}"
  end

  def parent_test_property(parent_table, var_number = nil)
    parent_property = parent_table
    parent_property = "#{parent_property}_#{var_number}" unless var_number.nil?
    parent_property
  end

  # Variable name stub resource is assigned to (i.e. @foo_bar)
  def resource_test_var(var_number = nil)
    "@#{resource_test_property(var_number)}"
  end

  # Symbol used to assign test resources (i.e. :foo_bar)
  def resource_test_sym(var_number = nil)
    ":#{resource_test_property(var_number)}"
  end

  # Generator for properties used for testing
  def resource_test_property(var_number = nil)
    resource_property = var_name
    resource_property = "#{resource_property}_#{var_number}" unless var_number.nil?
    resource_property
  end
  

end