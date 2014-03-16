require 'test_helper'

class NCommentTest < ActiveSupport::TestCase

  test "Should not save comment without content or without an association with a narrative" do
		
		comment_no_content = NComment.new(narrative_id: 980190962)
		assert !comment_no_content.save 

		comment_no_narrative = NComment.new(content: "asd")
		assert !comment_no_narrative.save

	end

end
