class AddAudioNumberToAudios < ActiveRecord::Migration
  def change
    add_column :audios, :audio_number, :integer
  end
end
