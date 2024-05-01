class ReportController < ApplicationController
  require 'boavizta'
  protect_from_forgery with: :null_session
  before_action :authorize_anonymous, :only=>[:add_record]

  def index
    @grouped = params[:grouped]
  end

  def show
    @user = User.find_by(username: params[:name])
    if @user
      @reports = @user.reports
    else
      @reports = Report.where("user_id IS ?", nil)
    end
  end

  def add_record
    data = JSON.parse(request.body.read)
    device = Device.find_by(uuid: data['device_id'])

    unless device
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

    render json: "Report saved successfully: Current carbon usage of #{report.current}kgCO2eq saved for #{@current_user ? @current_user.username : 'an anonymous user'}'s device '#{device.display_name}'"
  end
end
