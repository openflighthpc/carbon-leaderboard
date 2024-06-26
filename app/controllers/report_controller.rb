class ReportController < ApplicationController
  require 'boavizta'
  protect_from_forgery with: :null_session
  before_action :authorize_anonymous, :only=>[:add_record]

  def add_record
    data = JSON.parse(request.body.read)
    device = Device.find_by(uuid: data['device_id'])

    if device
      device.user_id = device.user_id || @current_user.id
      device.save
    else
      device = Device.create_from_json(data, @current_user) unless device
      if !device.errors.empty?
        render json: "Error(s) with payload data: #{device.errors.full_messages.join(', ')}"
        return
      end
    end
    report = Report.new(device_id: device.uuid,
                        current: Boavizta.carbon_for_load(device, data['current_load'])
                       )
    if report.valid?
      report.save
    else
      render json: "Error(s) with payload data: #{report.errors.full_messages.join(', ')}"
      return
    end

    render json: "Report saved successfully: Current carbon usage of #{report.current}gCO2eq saved for #{@current_user ? @current_user.username : 'an anonymous user'}'s device '#{device.display_name}'"
  end
end
