class CreateNComments < ActiveRecord::Migration
  def change
    create_table :n_comments do |t|
      t.integer :narrative_id
      t.text :content

      t.timestamps
    end
  end
end
