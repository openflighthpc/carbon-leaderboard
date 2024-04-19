class Report < ApplicationRecord
  belongs_to :device
  has_one :user, through: :device

  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
  end

  def add_tag(tag)
    self.tags |= [tag]
    self.tags.sort!
    self.save
  end

  def delete_tag(tag)
    self.tags -= [tag]
    self.tags.sort!
    self.save
  end
end
