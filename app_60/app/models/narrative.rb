class Narrative < ActiveRecord::Base
  has_many :audios, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :n_comments, dependent: :destroy
  validates :nar_name, presence: true
  validates :nar_path, presence: true
end
