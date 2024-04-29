class DataEntryController < ApplicationController
  def index
  end

  def download_carbon
    send_file(File.join(Rails.root, 'carbon-client', "carbon"))
  end

  def upload
    begin
      data = params[:device].read
                            .gsub("\n","")
                            .strip
                            .chomp(',')
      json = JSON.parse("[ #{data} ]")
                 .last
      device = Device.find_by(uuid: json['device_id'])
      if device
        refresh_page('Device has already been entered')
      else
        device = Device.create_from_json(json)
        refresh_page(device.errors.messages.values.join(', '))
      end
    rescue JSON::ParserError
      refresh_page('Invalid payload file format')
    rescue
      refresh_page('An unexpected error occurred')
    end
  end

  def refresh_page(upload_status)
    redirect_to action: index, upload_status: upload_status, anchor: 'step-card-3'
  end
end
