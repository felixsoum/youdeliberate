class CreateNarrativeCounts < ActiveRecord::Migration
  def change
    create_table :narrative_counts do |t|
      t.integer :value

      t.timestamps
    end
  end
end
