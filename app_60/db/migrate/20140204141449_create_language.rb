class CreateLanguage < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :language_name
      
      t.timestamps
    end
  end
end
