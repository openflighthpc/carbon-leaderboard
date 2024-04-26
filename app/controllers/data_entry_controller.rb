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
        refresh_page('Device has already been entered')
      else
        device = Device.create_from_json(data)
        refresh_page(device.errors.messages.values.join(', '))
      end
    rescue JSON::ParserError
      refresh_page('Invalid JSON file')
    end
  end

  def refresh_page(upload_status)
    redirect_to action: index, upload_status: upload_status, anchor: 'step-card-3'
  end
end