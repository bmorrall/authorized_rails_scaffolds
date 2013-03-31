class AuthorizedRailsScaffolds::ViewSpecHelper < AuthorizedRailsScaffolds::Helper

  def initialize(options = {})
    super options

    @attributes = options[:attributes]
  end

  def output_attributes
    @output_attributes ||= @attributes.reject{|attribute| [:timestamp].include? attribute.type }
  end

  def references_attributes
    @references_attributes ||= @attributes.reject{|attribute| ![:references].include? attribute.type }
  end

  def standard_attributes
    @standard_attributes ||= @attributes.reject{|attribute| [:time, :date, :datetime].include? attribute.type }
  end

  def datetime_attributes
    @datetime_attributes ||= @attributes.reject{|attribute| ![:time, :date, :datetime].include? attribute.type }
  end

end