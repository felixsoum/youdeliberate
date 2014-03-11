class Audio < ActiveRecord::Base
  belongs_to :narrative
  validates :narrative, presence: true
  validates :audio_path, presence: true
  validates :audio_number, presence: true
end
