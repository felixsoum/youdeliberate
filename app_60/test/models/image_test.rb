require 'test_helper'

class ImageTest < ActiveSupport::TestCase
    
  def setup
    @img = images(:one)
  end
  
  #this block of code is executed after every test
  def teardown
    @img = nil
  end
  
  test "should not save image without image_path or correct narrative id" do
    img_no_parent = Image.new(image_path: "path")
    assert !img_no_parent.save
    
    img_no_path = Image.new(narrative_id: 980190962)
    assert !img_no_path.save
    
    img_wrong_parent = Image.new(image_path: "path", narrative_id: 1)
    assert !img_wrong_parent.save 
  end
  
  test "should have has_many relationship between narratives and images" do
    assert_equal(980190962, @img.narrative_id)
    assert_equal(980190962, @img.narrative.id)
  end
  
end
