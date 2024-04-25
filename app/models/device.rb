class Device < ApplicationRecord
  self.primary_key = :uuid
  serialize :tags, coder: JSON
  serialize :disks, coder: JSON
  serialize :gpus, coder: JSON

  belongs_to :user, optional: true
  has_many :reports, dependent: :destroy

  validates :uuid, :cpus, :cores_per_cpu, :ram_units, :ram_capacity_per_unit, :platform,
            :location, :cpu_name, :cloud_provider, presence: { message: "is required" }

  def pretty_owner
    User.find_by(id: self.user_id)&.username || "Anonymous"
  end
end
