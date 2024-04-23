class ReportController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_anonymous, :only=>[:add_record]

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
    device = Device.find_by(uuid: data['user_id'])
    if !device
      device = Device.new(uuid: data['user_id'],
                          user_id: @current_user&.id,
                          cpus: data['cpus'],
                          cores_per_cpu: data['cores_per_cpu'],
                          ram_units: data['ram_units'],
                          ram_capacity_per_unit: data['ram_capacity_per_unit'],
                          min: data['min'],
                          half: data['half'],
                          max: data['max'],
                          platform: data['platform'],
                          location: data['location'],
                          tags: []
                         )
      device.save
    end

    report = Report.new(device_id: device.uuid,
                        current: data['current']
                       )
    report.save

    render json: "Report saved successfully: Current carbon usage of #{data['current']}kgCO2eq saved for #{@current_user ? @current_user.username : 'anonymous user'}."
  end
end

