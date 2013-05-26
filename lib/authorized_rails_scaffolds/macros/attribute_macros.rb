#
# requires attributes to be defined
#
module AuthorizedRailsScaffolds::Macros::AttributeMacros

  def output_attributes
    unless @output_attributes
      @output_attributes = []

      # First attribute
      @output_attributes << attributes.first unless attributes.empty?

      # Reference Attribtues
      @output_attributes += attributes[1..-1].reject{|attribute| ![:references].include? attribute.type }

      # Standard Attributes
      @output_attributes += attributes[1..-1].reject{|attribute| [:references].include? attribute.type }
    end
    @output_attributes
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