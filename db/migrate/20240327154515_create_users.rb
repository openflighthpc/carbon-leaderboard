class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false, primary_key: :user_id do |t|
      t.string :user_id
      t.string :name

      t.timestamps
    end
  end
end
