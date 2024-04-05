class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, type: :string
      t.integer :cpus
      t.integer :cores_per_cpu
      t.float :ram_units
      t.float :ram_capacity_per_unit
      t.float :min
      t.float :half
      t.float :max
      t.float :current
      t.datetime :time
      t.string :platform
      t.string :location

      t.timestamps
    end
  end
end
