class AuthorizedRailsScaffolds::RSpecScaffoldViewHelper < AuthorizedRailsScaffolds::RSpecScaffoldHelper
  include AuthorizedRailsScaffolds::Macros::AttributeMacros
  include AuthorizedRailsScaffolds::Macros::FactoryMacros

  def initialize(options = {})
    super options
  end

  def attributes
    @attributes
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