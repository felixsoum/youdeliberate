class AddIsPublishedToNarratives < ActiveRecord::Migration
  def change
    add_column :narratives, :is_published, :boolean, default: false
  end
end
