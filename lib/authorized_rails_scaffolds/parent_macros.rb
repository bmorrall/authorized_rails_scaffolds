module ParentMacros

  ### Parent Models ###

  # An array of parent model classes (i.e. ['User', 'Category])
  def parent_models
    @parent_models ||= AuthorizedRailsScaffolds.config.parent_models
  end

  # Table names of parent models (i.e. ['user', 'category'])
  def parent_model_names
    @parent_model_names ||= parent_models.map { |model| model.underscore }
  end

  # Variable name used to save a parent_table_name
  def parent_variable(parent_table_name)
    "@#{parent_table_name}"
  end
  
  def parent_sym(parent_table_name)
    ":#{parent_table_name}"
  end

  ### Parent Modules ###

  # The parent modules of a controller (i.e. ['Api', 'V1'])
  def parent_modules
    @parent_modules ||= modular_class_name.nil? ? [] : modular_class_name.split('::')[0..-2]
  end

  # Array of symbols used for links to parents (i.e. ['api', 'v1'])
  def parent_module_groups
    @parent_module_groups ||= parent_modules.map { |parent_module| parent_module.underscore }
  end

  # Returns the parent model required to create the model
  def model_parent_name(model_name)
    if model_name == resource_name
      return parent_model_names.any? ? parent_model_names.last : nil
    else
      parent_index = parent_model_names.index(model_name.to_s)
      if parent_index.nil? || parent_index == 0
        return nil
      else
        return parent_model_names[parent_index - 1]
      end
    end
    
  end

end