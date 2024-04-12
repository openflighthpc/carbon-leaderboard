class ReportController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    case params[:sort_column]
    when 'per_core'
      @reports = Report.all.order(Arel.sql('current * cpus * cores_per_cpu'))
    when 'per_ram'
      @reports = Report.all.order(Arel.sql('current * ram_units * ram_capacity_per_unit'))
    when 'time'
      @reports = Report.all.order(:created_at)
    else
      @reports = Report.all
    end
  end

  def show
    @user = User.find_by(username: params[:name])
    if @user
      @reports = Report.where("user_id = '#{@user&.id}'")
    else
      @reports = Report.where("user_id IS ?", nil)
    end
  end

  def add_record
    auth = authorize_request
    if auth[:errors]
      render json: "Authorization token invalid: #{auth[:errors]}"
      return
    end
    
    data = JSON.parse(request.body.read)

    user = User.find_by(id: auth[:user])

    device = Device.find_by(device_id: data['user_id'])
    if !device
      device = Device.new(device_id: data['user_id'],
                          user_id: user&.id
                         )
      device.save
    end

    report = Report.new(user_id: user&.id,
                        platform: data['platform'],
                        cpus: data['cpus'],
                        cores_per_cpu: data['cores_per_cpu'],
                        ram_units: data['ram_units'],
                        ram_capacity_per_unit: data['ram_capacity_per_unit'],
                        min: data['min'],
                        half: data['half'],
                        max: data['max'],
                        current: data['current'],
                        location: data['location']
                       )
    report.save

    render json: "Report saved successfully: Current carbon usage of #{data['current']}kgCO2eq saved for #{user ? user.username : 'anonymous user'}."
  end
end

