class ReportController < ApplicationController
  protect_from_forgery with: :null_session

  def home
  end

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
    @user = User.find_by(name: params[:name])
    @reports = Report.where("user_id = '#{@user.user_id}'")
  end

  def add_record
    data = JSON.parse(request.body.read)

    user = User.find_by(user_id: data['user_id'])
    if !user
      colours = %w(red orange yellow green blue indigo violet pink purple grey)
      animals = %w(dog cat chicken duck otter lion tiger fish snake dragon)

      name = "#{colours[rand(10)]}_#{animals[rand(10)]}#{rand(100)}"
      while User.find_by(name: name)
        name = "#{colours[rand(10)]}_#{animals[rand(10)]}#{rand(100)}"
      end

      user = User.new(user_id: data['user_id'],
                      name: name
                     )
      user.save
    end

    report = Report.new(user_id: user.user_id,
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

    render json: "Report saved successfully: Current carbon usage of #{data['current']}kgCO2eq for #{user.name}"
  end
end

