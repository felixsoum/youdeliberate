require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  test "IT-UF-1: User open single narrative, comment on and agree with it" do
    @narrative = narratives(:one)

    https!
    get "/narratives/#{@narrative.id}/play"
    assert_response :success

    assert_difference('NComment.where(narrative_id: @narrative.id).count') do
      post_via_redirect "/narratives/#{@narrative.id}/comment", :format => 'js', id: @narrative.id, user_submitted_comment:  "I hate you and your goddamned opinion!"
    end

    assert_difference("Narrative.find(@narrative.id).num_of_agree", 1) do
      post_via_redirect "/narratives/#{@narrative.id}/agree", id: @narrative.id, :format => :json
    end

  end

  test "IT-UF-2: User open single narrative and flag it" do
    @narrative = narratives(:two)

    https!
    get "/narratives/#{@narrative.id}/play"
    assert_response :success

    assert_difference(['Narrative.find(@narrative.id).num_of_flagged', 'ActionMailer::Base.deliveries.size']) do
      post_via_redirect "/narratives/#{@narrative.id}/flag", id: @narrative.id, :format => :json
    end

    assert_no_difference ['ActionMailer::Base.deliveries.size'] do
      post_via_redirect "/narratives/#{@narrative.id}/flag", id: @narrative.id, :format => :json
    end

    reason_email = ActionMailer::Base.deliveries.last
    assert_equal Admin.first.user_name, reason_email.to[0]

  end


end
