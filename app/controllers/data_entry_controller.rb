class DataEntryController < ApplicationController
  def index
  end

  def download_carbon
    send_file(File.join(Rails.root, 'carbon-client', "carbon"))
  end

  def upload
    data = JSON.parse params[:device].read
                                     .gsub("\n","")
                                     .strip
                                     .chomp(',')
    Device.create_from_json(data)
  end
end
