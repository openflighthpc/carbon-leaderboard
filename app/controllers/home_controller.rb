class HomeController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @devices = Device.left_joins(:user)
                     .select('devices.*, users.username, max / (cpus * cores_per_cpu) AS max_per_core')
                     .order(:max_per_core)
                     .first(3)
                     .pluck(:uuid, :platform, :location)

  end
end

