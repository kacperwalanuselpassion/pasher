class NumberFormatter
  include ActionView::Helpers::NumberHelper

  def number_to_pln(number)
    number_to_currency number, unit: 'PLN', format: '%n %u', separator: ',', delimiter: '.' if number.is_a?(Numeric)
  end
end