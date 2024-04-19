class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices, id: false, primary_key: :uuid do |t|
      t.string :uuid
      t.references :user
      t.integer :cpus
      t.integer :cores_per_cpu
      t.float :ram_units
      t.float :ram_capacity_per_unit
      t.float :min
      t.float :half
      t.float :max
      t.string :platform
      t.string :location

      t.timestamps
    end
  end
end
