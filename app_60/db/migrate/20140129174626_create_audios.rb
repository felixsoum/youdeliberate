class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.integer :narrative_id
      t.string :audio_path

      t.timestamps
    end
  end
end
