class ReportController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authorize_anonymous, :only=>[:add_record]
  before_action :authorize_request, :only=>[:add_tag, :delete_tag] # Swap this to :except=> if it results in a smaller set of methods

  def show
    @user = User.find_by(username: params[:name])
    if @user
      @reports = Report.where("user_id = '#{@user&.id}'")
    else
      @reports = Report.where("user_id IS ?", nil)
    end
  end

  def add_record
    data = JSON.parse(request.body.read)
    device = Device.find_by(device_id: data['user_id'])
    if !device
      device = Device.new(device_id: data['user_id'],
                          user_id: @current_user&.id
                         )
      device.save
    end

    report = Report.new(user_id: @current_user&.id,
                        platform: data['platform'],
                        cpus: data['cpus'],
                        cores_per_cpu: data['cores_per_cpu'],
                        ram_units: data['ram_units'],
                        ram_capacity_per_unit: data['ram_capacity_per_unit'],
                        min: data['min'],
                        half: data['half'],
                        max: data['max'],
                        current: data['current'],
                        location: data['location'],
                        tags: []
                       )
    report.save

    render json: "Report saved successfully: Current carbon usage of #{data['current']}kgCO2eq saved for #{@current_user ? @current_user.username : 'anonymous user'}."
  end

  def raw_data
    reports = Report.order(:max)
    response = {}.tap do |res|
      res[:max_main] = reports.last.max
      res[:header] = {}.tap do |h|
        h[:user] = 'User'
        h[:platform] = 'Platform'
        h[:location] = 'Location'
        h[:core_number] = 'No. cores'
        h[:ram] = 'RAM (GB)'
        h[:main] = 'Carbon emissions per core at full load (kgCO2eq/h)'
      end
      rank = 1
      res[:reports] = reports
      .group_by(&:max)
      .values.flat_map do |rep_group|
        current_rank = rank
        rank += rep_group.size
        rep_group.map do |rep|
          {}.tap do |new_rep|
            new_rep[:rank] = current_rank
            new_rep[:user] = rep.pretty_owner
            new_rep[:platform] = rep.platform
            new_rep[:location] = rep.location
            new_rep[:core_number] = rep.cpus * rep.cores_per_cpu
            new_rep[:ram] = rep.ram_units * rep.ram_capacity_per_unit
            new_rep[:main] = rep.max
          end
        end
      end
    end
    render json: response
  end

  def add_tag
    report = Report.find(params[:report])
    if report.user_id == @current_user.id
      report.add_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end

  def delete_tag
    report = Report.find(params[:report])
    if report.user_id == @current_user.id
      report.delete_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end
end

