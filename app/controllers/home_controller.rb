class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @groups = Device.select('devices.*, max / (cpus * cores_per_cpu) AS max_per_core')
                     .group(:group)
                     .order(:max_per_core)
                     .first(3)
                     .map do |device|
      {
        display_name: device.pretty_group,
        count: Device.where(:group => device.group).count,
        platform: device.platform,
        location: device.two_digit_location,
        group_index: device.group
      }
    end
    @num_devices = Device.all.length
    @num_groups = Device.select(:group).distinct.length
  end
end

