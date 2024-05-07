module ReportHelper
  # Return username in cases where user could be anonymous
  def username(user_id)
    User.find_by(id: user_id)&.username || "Anonymous"
  end
end
