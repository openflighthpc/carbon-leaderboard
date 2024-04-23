class AddMoreDataToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :cpu_name, :string
    add_column :devices, :disks, :text
    add_column :devices, :gpus, :text
    add_column :devices, :cloud_provider, :string
    add_column :devices, :instance_type, :string
  end
end
