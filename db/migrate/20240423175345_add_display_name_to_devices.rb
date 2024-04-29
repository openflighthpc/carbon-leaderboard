class AddDisplayNameToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :display_name, :string
  end
end
