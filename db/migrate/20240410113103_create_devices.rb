class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices, id: false, primary_key: :device_id do |t|
      t.string :device_id
      t.references :user

      t.timestamps
    end
  end
end
