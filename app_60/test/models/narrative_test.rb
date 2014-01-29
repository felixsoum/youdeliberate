require 'test_helper'

class NarrativeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save narratives without name" do
    nar = Narrative.new
    assert !nar.save
  end
end