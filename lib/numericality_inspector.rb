class NumericalityInspector
  def number?(object)
    object.is_a?(Numeric) && !non_numeric_float?(object)
  end

  def non_numeric_float?(object)
    object.is_a?(Float) && (object.nan? || !object.finite?)
  end
end