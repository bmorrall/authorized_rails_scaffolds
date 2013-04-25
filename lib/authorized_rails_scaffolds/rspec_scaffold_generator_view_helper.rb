class AuthorizedRailsScaffolds::RSpecScaffoldGeneratorViewHelper < AuthorizedRailsScaffolds::RSpecScaffoldGeneratorHelper

  def initialize(options = {})
    super options
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

  def date_select_year_value(date_string)
    DateTime.parse(date_string).strftime('%Y')
  end

  def date_select_month_value(date_string)
    DateTime.parse(date_string).strftime('%-m')
  end

  def date_select_month_text(date_string)
    DateTime.parse(date_string).strftime('%B')
  end

  def date_select_day_value(date_string)
    DateTime.parse(date_string).strftime('%-d')
  end

  def date_select_hour_value(date_string)
    DateTime.parse(date_string).strftime('%H')
  end

  def date_select_minute_value(date_string)
    DateTime.parse(date_string).strftime('%M')
  end

end