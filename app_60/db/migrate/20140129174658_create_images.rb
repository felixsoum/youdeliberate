class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :narrative_id
      t.string :image_path

      t.timestamps
    end
  end
end
