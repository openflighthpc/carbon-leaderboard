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
        existing = true
      else
        existing = false
        device = Device.create_from_json(json)
      end
      if device.errors.empty?
        Report.create(device_id: device.uuid,
                      current: Boavizta.carbon_for_load(device, data['current_load'])
        )
        refresh_page("Device #{device.display_name} successfully #{existing ? 'updated' : 'entered'}")
      else
        refresh_page(device.errors.full_messages.join(', '))
      end

    rescue JSON::ParserError
      refresh_page('Invalid payload file format')
    rescue
      refresh_page('An unexpected error occurred')
    end
  end

  def refresh_page(upload_status, offline_instructions = true)
    redirect_to action: index,
                upload_status: upload_status,
                offline_instructions: offline_instructions,
                anchor: 'anchor-card'
  end
end
