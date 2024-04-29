class ReportController < ApplicationController
  require 'boavizta'
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
    device = Device.find_by(uuid: data['device_id'])
    if !device
      device = Device.new(uuid: data['device_id'],
                          display_name: new_name,
                          user_id: @current_user&.id,
                          cpus: data['cpus'],
                          cores_per_cpu: data['cores_per_cpu'],
                          cpu_name: data['cpu_name'],
                          ram_units: data['ram_units'],
                          ram_capacity_per_unit: data['ram_capacity_per_unit'],
                          disks: data['disk'] || [],
                          gpus: data['gpu'] || [],
                          platform: data['platform'],
                          location: data['location'],
                          tags: data['tags'] || []
                         )
      if device.valid?
        device.cloud_provider = Boavizta.provider(device.platform)
        device.instance_type = data['instance_type'] if Boavizta.type_exists?(data['instance_type'], device.cloud_provider)
        device.min = Boavizta.carbon_for_load(device, 0)
        device.half = Boavizta.carbon_for_load(device, 50)
        device.max = Boavizta.carbon_for_load(device, 100)
        device.save
      else
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

  def new_name
    colours = %w(Red Orange Yellow Green Blue Indigo Violet Pink Purple Grey)
    adjs = %w(Big Small Quick Slow Mad Calm Good Bad Brave Lucky)
    animals = %w(Dog Cat Chicken Duck Otter Lion Tiger Fish Snake Dragon)

    name = "#{adjs[rand(10)]}#{colours[rand(10)]}#{animals[rand(10)]}#{rand(100)}"
    while Device.find_by(display_name: name)
      name = "#{adjs[rand(10)]}#{colours[rand(10)]}#{animals[rand(10)]}#{rand(100)}"
    end
    name
  end
end

