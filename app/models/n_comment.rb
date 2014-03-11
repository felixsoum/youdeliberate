class NComment < ActiveRecord::Base
belongs_to :narrative
validates :narrative, presence: true
validates :content, presence: true
end

