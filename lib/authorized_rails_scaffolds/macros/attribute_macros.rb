#
# requires attributes to be defined
#
module AuthorizedRailsScaffolds::Macros::AttributeMacros

  def output_attributes
    @output_attributes ||= attributes.reject{|attribute| [:timestamp].include? attribute.type }
  end

  def references_attributes
    @references_attributes ||= output_attributes.reject{|attribute| ![:references].include? attribute.type }
  end

  def standard_attributes
    @standard_attributes ||= output_attributes.reject{|attribute| [:time, :date, :datetime, :references].include? attribute.type }
  end

  def datetime_attributes
    @datetime_attributes ||= output_attributes.reject{|attribute| ![:time, :date, :datetime].include? attribute.type }
  end

end