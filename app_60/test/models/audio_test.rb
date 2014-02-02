require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  
  def setup
    @aud = audios(:one)
  end
  
  #this block of code is executed after every test
  def teardown
    @aud = nil
  end
  
  test "should not save image without audio path or correct narrative id" do
    aud_no_parent = Audio.new(audio_path: "path")
    assert !aud_no_parent.save
    
    aud_no_path = Audio.new(narrative_id: 980190962)
    assert !aud_no_path.save
    
    aud_wrong_parent = Audio.new(audio_path: "path", narrative_id: 1)
    assert !aud_wrong_parent.save       
  end
  
  test "should have belongs_to relationship between audios and narratives" do
    #check the foreign key of the audio is correct.
    assert_equal(298486374, @aud.narrative_id)
    #check parent(narrative) can be reached from child(audio)
    assert_equal(298486374, @aud.narrative.id)
  end
  
end
