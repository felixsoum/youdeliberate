require 'test_helper'

class NarrativeTest < ActiveSupport::TestCase

  #this block of code is executed before every test
  def setup
    @nar_1 = narratives(:one)
    @nar_2 = narratives(:two)
  end
  
  #this block of code is executed after every test
  def teardown
    @nar_1 = nil
    @nar_2 = nil
  end
  
  test "should not save narratives without name or path" do
    nar_no_name = Narrative.new(nar_path: "narrative_path", language_id: 1, num_of_view: 0,
                                      num_of_agree: 0, num_of_disagree: 0, num_of_flagged: 0)
    assert !nar_no_name.save
    
    nar_no_path = Narrative.new(nar_name: "narrative_name", language_id: 1, num_of_view: 0,
                                      num_of_agree: 0, num_of_disagree: 0, num_of_flagged: 0)
    assert !nar_no_path.save
  end
  
  test "should have has_many relationship between narratives and images" do
    #check the number of children is correct
    assert_equal(2, @nar_1.images.count)
    #check the children can be reached from parent and their foreign keys are correct.
    assert_equal([980190962,980190962], @nar_1.images.collect {|img| img.narrative_id })
  end
  
  test "should have has_many relationship between narratives and audios" do
    assert_equal(2, @nar_2.audios.count)
    assert_equal([298486374,298486374], @nar_2.audios.collect {|aud| aud.narrative_id })
  end
  
  test "should destroy corresponding images when destroy a narrative" do
    #check the total number of images should be changed correct.
    assert_difference("Image.count", -@nar_1.images.count) do
      @nar_1.destroy
    end
    #Check the images are deleted correctly
    assert_nil(Image.find_by_narrative_id(980190962))
  end
  
  test "should destroy corresponding audios when destroy a narrative" do
    assert_difference("Audio.count", -@nar_2.audios.count) do
      @nar_2.destroy
    end
    
    assert_nil(Audio.find_by_narrative_id(298486374))
  end
  
end