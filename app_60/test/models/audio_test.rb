require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  test "should not save image without narrative id" do
    aud = Audio.new
    assert !aud.save
  end
end
