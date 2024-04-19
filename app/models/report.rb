class Report < ApplicationRecord
<<<<<<< HEAD
  belongs_to :device
  has_one :user, through: :device

  def add_tag(tag)
    self.tags |= [tag]
    self.tags.sort!
    self.save
  end

  def delete_tag(tag)
    self.tags -= [tag]
    self.tags.sort!
    self.save
=======
  belongs_to :user

  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
>>>>>>> 5f1e349 (greatly improve query efficiency)
  end
end
