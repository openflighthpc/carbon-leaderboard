class DeviceController < ApplicationController
  before_action :authorize_request, :only=>[:add_tag, :delete_tag]

  def show
    @device = Device.find_by(display_name: params[:device])
  end

  def add_tag
    device = Device.find_by(display_name: params[:device])
    if device.user_id == @current_user.id
      report.add_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end

  def delete_tag
    device = Device.find_by(display_name: params[:device])
    if device.user_id == @current_user.id
      report.delete_tag(request.body.read)
    else
      render json: "Error: User does not own specified report"
    end
  end
end
