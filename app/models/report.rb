class Report < ApplicationRecord
  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
  end
end
