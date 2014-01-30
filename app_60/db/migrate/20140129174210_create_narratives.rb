class CreateNarratives < ActiveRecord::Migration
  def change
    create_table :narratives do |t|
      t.string :nar_name
      t.string :nar_path
      t.integer :language_id
      t.integer :category_id
      t.string :first_image
      t.integer :num_of_view
      t.integer :num_of_agree
      t.integer :num_of_disagree
      t.integer :num_of_flagged
      t.datetime :create_time

      t.timestamps
    end
  end
end
