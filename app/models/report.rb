class Report < ApplicationRecord
  belongs_to :device
  has_one :user, through: :device

  validates :current, presence: { message: "is required" }

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
