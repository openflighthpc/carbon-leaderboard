module ReportHelper
  # Round a float to a specified number of significant figures
  def signif(val, digits)
    return 0 if val.zero?
    val.round(-(Math.log10(val).ceil - digits))
  end
end
