module ReportHelper
  # Round a float to a specified number of significant figures
  def signif(val, digits)
    return 0 if val.zero?
    val.round(-(Math.log10(val).ceil - digits))
  end

  # Return username in cases where user could be anonymous
  def username(user_id)
    User.find_by(id: user_id)&.username || "Anonymous"
  end
end
