class DataEntryController < ApplicationController
  def index
  end

  def download_carbon
    send_file(File.join(Rails.root, 'carbon-client', "carbon"))
  end

  def upload
    begin
      data = JSON.parse params[:device].read
                                       .gsub("\n","")
                                       .strip
                                       .chomp(',')
      device = Device.find_by(uuid: data['device_id'])
      if device
        redirect_to action: index, upload_status: 'Device has already been entered'
      else
        device = Device.create_from_json(data)
        redirect_to action: index, upload_status: device.errors.messages.values.join(', ')
      end
    rescue JSON::ParserError
      redirect_to action: index, upload_status: 'Invalid JSON file'
    end
  end
end
