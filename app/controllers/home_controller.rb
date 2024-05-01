class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @devices = Device.left_joins(:user)
                     .select('devices.*, users.username, max / (cpus * cores_per_cpu) AS max_per_core')
                     .order(:max_per_core)
                     .first(3)
                     .map do |device|
      {
        display_name: device.display_name,
        user: device.pretty_owner,
        platform: device.platform,
        location: device.two_digit_location,
      }
    end
    @num_devices = Device.all.length
    @num_configs = Device.select(:group).distinct.length
  end
end

