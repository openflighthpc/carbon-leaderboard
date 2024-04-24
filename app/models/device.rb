class Device < ApplicationRecord
  self.primary_key = :uuid
  serialize :tags, coder: JSON
  serialize :disks, coder: JSON
  serialize :gpus, coder: JSON

  belongs_to :user, optional: true
  has_many :reports, dependent: :destroy

  validates :uuid, :cpus, :cores_per_cpu, :ram_units, :ram_capacity_per_unit, :platform,
            :location, :cpu_name, presence: { message: "is required" }

  def pretty_owner
    user&.username || "Anonymous"
  end

  def two_digit_location
    ISO3166::Country.find_country_by_alpha3(self.location).alpha2
  end
end
