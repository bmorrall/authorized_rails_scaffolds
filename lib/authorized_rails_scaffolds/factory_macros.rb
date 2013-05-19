module FactoryMacros

  # Returns code that will generate attribute_value as an attribute_type
  def factory_attribute_value(attribute_type, attribute_value)
    case attribute_type
    when :datetime
      "DateTime.parse(#{attribute_value})"
    when :time
      value_as_time = attribute_value.to_time.strftime('%T')
      "Time.parse(#{value_as_time.dump})"
    when :date
      value_as_date = attribute_value.to_time.strftime('%Y-%m-%d')
      "Date.parse(#{value_as_date.dump})"
    else
      attribute_value
    end
  end

  # Returns the expected output string of attribute_value if it is an attribute_type
  def factory_attribute_string(attribute_type, attribute_value)
    case attribute_type
    when :datetime
      attribute_value_as_date = DateTime.parse(attribute_value)
      I18n.l(attribute_value_as_date, :format => :long).dump
    when :time
      attribute_value_as_time = Time.parse(attribute_value)
      I18n.l(attribute_value_as_time, :format => :short).dump
    when :date
      attribute_value_as_date = Date.parse(attribute_value)
      I18n.l(attribute_value_as_date).dump
    else
      attribute_value
    end
  end

  def create_resource_from_factory
    extra_factory_params = build_extra_factory_params
    "FactoryGirl.create(#{resource_symbol}#{extra_factory_params})"
  end

  def create_parent_resource_from_factory(parent_table_name)
    extra_factory_params = build_extra_factory_params(parent_table_name)
    "FactoryGirl.create(:#{parent_table_name}#{extra_factory_params})"
  end

  protected

  def build_extra_factory_params(parent_table_name = nil)
    if parent_table_name.nil?
      attribute = parent_model_names.last
    else
      parent_index = parent_model_names.index(parent_table_name.to_s)
      unless parent_index.nil? || parent_index == 0
        attribute = parent_model_names[parent_index - 1]
      end
    end

    if attribute.nil?
      return ''
    else
      return ", :#{attribute} => #{references_test_name(attribute)}"
    end
  end

end