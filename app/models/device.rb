class Device < ApplicationRecord
  self.primary_key = :uuid
  serialize :tags, coder: JSON
  serialize :disks, coder: JSON
  serialize :gpus, coder: JSON
  belongs_to :user, optional: true
  has_many :reports, dependent: :destroy

  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
  end
end
