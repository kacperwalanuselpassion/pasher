class NumberFormatter
  include ActionView::Helpers::NumberHelper

  def number_to_pln(number)
    if NumericalityInspector.new.number?(number)
      number_to_currency number, unit: 'PLN', format: '%n %u', separator: ',', delimiter: '.'
    end
  end
end