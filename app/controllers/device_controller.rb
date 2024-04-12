class DeviceController < ApplicationController
  def show
    @devices = Device.all
  end
end
