require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test "should not save image without narrative id" do
    img = Image.new
    assert !img.save
  end
end
