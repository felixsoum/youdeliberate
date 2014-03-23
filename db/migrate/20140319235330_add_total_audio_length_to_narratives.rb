class AddTotalAudioLengthToNarratives < ActiveRecord::Migration
  def change
    add_column :narratives, :total_audio_length, :int
  end
end
