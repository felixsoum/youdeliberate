class AddImageNumberToImagesTable < ActiveRecord::Migration
  def change
    add_column :images, :image_number, :integer
  end
end
