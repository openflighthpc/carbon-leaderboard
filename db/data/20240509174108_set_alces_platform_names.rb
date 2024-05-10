# frozen_string_literal: true

class SetAlcesPlatformNames < ActiveRecord::Migration[7.1]
  def up
    Device.find_each do |device|
      device.platform = 'Alces Cloud' if device.platform=='OpenStack' && Boavizta.type_exists?(device.instance_type, 'alces')
      device.save
    end
  end

  def down
    Device.where(platform: 'Alces Cloud').each do |device|
      device.platform = 'OpenStack'
      device.save
    end
  end
end
