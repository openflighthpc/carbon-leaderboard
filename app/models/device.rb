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

  def config_attributes
    self.attributes.filter do |attr|
      !%w(uuid user_id created_at updated_at tags display_name group).include?(attr)
    end
  end

  def determine_group
    group_devices = Device.all.group(:group).where.not(uuid: self.uuid)
    group_devices.each do |device|
      if self.config_attributes == device.config_attributes
        return device.group
      end
    end
    group_devices.length
  end
end
