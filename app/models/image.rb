class Image < ActiveRecord::Base
  belongs_to :narrative
  validates :narrative, presence: true
  validates :image_path, presence: true
  validates :image_number, presence: true
end
