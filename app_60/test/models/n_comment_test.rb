require 'test_helper'

class NCommentTest < ActiveSupport::TestCase

  test "should not save comment without necessary information" do
		
		comment_no_content = NComment.new(narrative_id: 980190962)
		assert !comment_no_content.save 

		comment_no_narrative = NComment.new(content: "asd")
		assert !comment_no_narrative.save

	end

end
