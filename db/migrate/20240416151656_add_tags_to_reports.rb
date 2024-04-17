class AddTagsToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :tags, :text, default: "[]"
  end
end
