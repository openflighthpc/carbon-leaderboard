class DeviceController < ApplicationController
  before_action :authorize_request, :only=>[:add_tag, :delete_tag]

  def show
    @devices = Device.all
  end

  def raw_data
    devices = Device.left_joins(:user)
    .select('devices.*, users.username, max / (cpus * cores_per_cpu) AS max_per_core')
    .order(:max_per_core)
    response = {}.tap do |res|
      max_device = devices.last
      res[:max_main] = max_device&.max_per_core&.round(3);
      res[:header] = {}.tap do |h|
        h[:user] = 'User'
        h[:platform] = 'Platform'
        h[:location] = 'Location'
        h[:core_number] = 'No. cores'
        h[:ram] = 'RAM (GB)'
        h[:main] = 'Carbon emissions per core at full load (kgCO2eq/h)'
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
            new_dev[:user] = dev.username || 'Anonymous'
            new_dev[:platform] = dev.platform
            new_dev[:location] = dev.location
            new_dev[:core_number] = dev.cpus * dev.cores_per_cpu
            new_dev[:ram] = dev.ram_units * dev.ram_capacity_per_unit
            new_dev[:main] = dev.max_per_core.round(3);
          end
        end
      end
    end
    render json: response
  end

  def add_tag
    device = Device.find(params[:device])
    if device.user_id == @current_user.id
      report.add_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end

  def delete_tag
    device = Device.find(params[:device])
    if device.user_id == @current_user.id
      report.delete_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end
end
