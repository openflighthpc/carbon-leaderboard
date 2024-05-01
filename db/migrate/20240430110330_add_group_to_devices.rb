class AddGroupToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :group, :integer
  end
end
