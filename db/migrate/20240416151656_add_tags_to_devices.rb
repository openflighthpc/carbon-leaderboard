class AddTagsToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :tags, :text, default: "[]"
  end
end
