class ReportController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @reports = Report.all
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
                        cpus: data['cpus'],
                        ram: data['ram'],
                        min: data['min'],
                        half: data['half'],
                        max: data['max'],
                        avg: data['avg']
                       )
    report.save

    render json: "Report saved successfully: Average carbon usage of #{data['avg']}kgCO2eq for #{user.name}"
  end
end

