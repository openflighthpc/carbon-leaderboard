class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @devices = Device.left_joins(:user)
                     .select('devices.*, users.username, max / (cpus * cores_per_cpu) AS max_per_core')
                     .order(:max_per_core)
                     .first(3)
                     .map do |device|
      {
        uuid: device.uuid,
        user: device.pretty_owner,
        platform: device.platform,
        location: device.two_digit_location,
      }
    end
    @num_devices = Device.all.length
    config_attributes = Device.attribute_names.filter do |attr|
      !%w(uuid user_id created_at updated_at tags).include?(attr)
    end
    @num_configs = Device.all.pluck(config_attributes).uniq.length
  end
end

