class Image < ActiveRecord::Base
  belongs_to :narrative
  validates :narrative_id, presence: true
end
