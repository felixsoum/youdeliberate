class Narrative < ActiveRecord::Base
  has_many :audios, dependent: :destroy
  has_many :images, dependent: :destroy
  validates :nar_name, presence: true
end
