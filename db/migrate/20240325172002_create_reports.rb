class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :user, type: :string
      t.integer :cpus
      t.float :ram
      t.float :min
      t.float :half
      t.float :max
      t.float :avg
      t.datetime :time

      t.timestamps
    end
  end
end
