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
      device = Device.find_by(uuid: json.last['device_id'])
      if device
        existing = true
      else
        existing = false
        device = Device.create_from_json(json.last)
      end
      if device.errors.empty?
        json.each do |payload|
          Report.create(device_id: device.uuid,
                        current: Boavizta.carbon_for_load(device, payload['current_load']),
                        created_at: DateTime.parse(payload['timestamp'])
          )
        end
        refresh_page("Device #{device.display_name} successfully #{existing ? 'updated' : 'entered'} with #{json.length} new entries")
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
