# frozen_string_literal: true

class SetUnitsToGrams < ActiveRecord::Migration[7.1]
  def up
    Device.all.each do |device|
      device.min = device.min * 1000
      device.half = device.half * 1000
      device.max = device.max * 1000
      device.save
    end
    Report.all.each do |report|
      report.current = report.current * 1000
      report.save
    end
  end

  def down
    Device.all.each do |device|
      device.min = device.min / 1000
      device.half = device.half / 1000
      device.max = device.max / 1000
      device.save
    end
    Report.all.each do |report|
      report.current = report.current / 1000
      report.save
    end
  end
end
