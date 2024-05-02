class GroupController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @groups = Device.select('devices.*, max / (cpus * cores_per_cpu) AS max_per_core')
                     .group(:group)
                     .order(:max_per_core)
                     .map do |device|
      {
        display_name: "#{device.platform}-#{device.instance_type || "Group#{device.group}"}-#{device.location}",
        count: Device.where(:group => device.group).count,
        platform: device.platform,
        location: device.two_digit_location,
        group_index: device.group
      }
    end
  end

  def show
  end

  def raw_data
    devices = Device.select('devices.*, max / (cpus * cores_per_cpu) AS max_per_core')
    .group(:group)
    .order(:max_per_core)
    response = {}.tap do |res|
      max_device = devices.last
      res[:max_main] = max_device&.max_per_core&.round(3);
      res[:header] = {}.tap do |h|
        h[:user] = 'Group'
        h[:platform] = 'Platform'
        h[:location] = 'Location'
        h[:core_number] = 'No. cores'
        h[:ram] = 'RAM (GB)'
        h[:main] = 'Carbon emissions per core at full load (CO2eq/h)'
      end
      rank = 1
      res[:devices] = devices
      .group_by(&:max_per_core)
      .values.flat_map do |dev_group|
        current_rank = rank
        rank += dev_group.size
        dev_group.map do |dev|
          {}.tap do |new_dev|
            new_dev[:rank] = current_rank
            new_dev[:user] = "#{dev.platform}-#{dev.instance_type || "Group#{dev.group}"}-#{dev.location}"
            new_dev[:platform] = dev.platform
            new_dev[:location] = dev.location
            new_dev[:core_number] = dev.cpus * dev.cores_per_cpu
            new_dev[:ram] = dev.ram_units * dev.ram_capacity_per_unit
            new_dev[:main] = "#{dev.max_per_core.round(4)}g"
          end
        end
      end
    end
    render json: response
  end
end

