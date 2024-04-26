class Device < ApplicationRecord
  self.primary_key = :uuid
  serialize :tags, coder: JSON
  serialize :disks, coder: JSON
  serialize :gpus, coder: JSON

  belongs_to :user, optional: true
  has_many :reports, dependent: :destroy

  validates :uuid, :cpus, :cores_per_cpu, :ram_units, :ram_capacity_per_unit, :platform,
            :location, :cpu_name, presence: { message: "is required" }

  def self.create_from_json(data, user = nil)
    begin
      device = Device.new(uuid: data['device_id'],
                          display_name: new_name,
                          user_id: user&.id,
                          cpus: data['cpus'],
                          cores_per_cpu: data['cores_per_cpu'],
                          cpu_name: data['cpu_name'],
                          ram_units: data['ram_units'],
                          ram_capacity_per_unit: data['ram_capacity_per_unit'],
                          disks: data['disk'] || [],
                          gpus: data['gpu'] || [],
                          platform: data['platform'],
                          location: data['location'],
                          tags: data['tags'] || []
      )
      if device.valid?
        device.cloud_provider = Boavizta.provider(device.platform)
        device.instance_type = data['instance_type'] if Boavizta.type_exists?(data['instance_type'], device.cloud_provider)
        device.min = Boavizta.carbon_for_load(device, 0)
        device.half = Boavizta.carbon_for_load(device, 50)
        device.max = Boavizta.carbon_for_load(device, 100)
        device.group = device.determine_group
        device.save
      end
    ensure
      return device
    end
  end

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
    group_devices = Device.group(:group).where.not(uuid: self.uuid)
    group_devices.each do |device|
      if self.config_attributes == device.config_attributes
        return device.group
      end
    end
    Device.pluck(:group).compact.max.to_i + 1
  end

  def new_name
    colours = %w(Red Orange Yellow Green Blue Indigo Violet Pink Purple Grey)
    adjs = %w(Big Small Quick Slow Mad Calm Good Bad Brave Lucky)
    animals = %w(Dog Cat Chicken Duck Otter Lion Tiger Fish Snake Dragon)

    name = "#{adjs[rand(10)]}#{colours[rand(10)]}#{animals[rand(10)]}#{rand(100)}"
    while Device.find_by(display_name: name)
      name = "#{adjs[rand(10)]}#{colours[rand(10)]}#{animals[rand(10)]}#{rand(100)}"
    end
    name
  end
end
