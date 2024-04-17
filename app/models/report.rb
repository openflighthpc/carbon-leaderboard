class Report < ApplicationRecord
  serialize :tags, coder: YAML

  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
  end
end
