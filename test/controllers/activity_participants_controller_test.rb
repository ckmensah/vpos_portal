require 'test_helper'

class ActivityParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_participant = activity_participants(:one)
  end

  test "should get index" do
    get activity_participants_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_participant_url
    assert_response :success
  end

  test "should create activity_participant" do
    assert_difference('ActivityParticipant.count') do
      post activity_participants_url, params: { activity_participant: { active_status: @activity_participant.active_status, assigned_code: @activity_participant.assigned_code, comment: @activity_participant.comment, del_status: @activity_participant.del_status, division_code: @activity_participant.division_code, image_data: @activity_participant.image_data, image_path: @activity_participant.image_path, participant_alias: @activity_participant.participant_alias, participant_name: @activity_participant.participant_name, user_id: @activity_participant.user_id } }
    end

    assert_redirected_to activity_participant_url(ActivityParticipant.last)
  end

  test "should show activity_participant" do
    get activity_participant_url(@activity_participant)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_participant_url(@activity_participant)
    assert_response :success
  end

  test "should update activity_participant" do
    patch activity_participant_url(@activity_participant), params: { activity_participant: { active_status: @activity_participant.active_status, assigned_code: @activity_participant.assigned_code, comment: @activity_participant.comment, del_status: @activity_participant.del_status, division_code: @activity_participant.division_code, image_data: @activity_participant.image_data, image_path: @activity_participant.image_path, participant_alias: @activity_participant.participant_alias, participant_name: @activity_participant.participant_name, user_id: @activity_participant.user_id } }
    assert_redirected_to activity_participant_url(@activity_participant)
  end

  test "should destroy activity_participant" do
    assert_difference('ActivityParticipant.count', -1) do
      delete activity_participant_url(@activity_participant)
    end

    assert_redirected_to activity_participants_url
  end
end
