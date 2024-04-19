class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :device
      t.float :current

      t.timestamps
    end
  end
end
