require 'test_helper'

class ActivityTypeMediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_type_medium = activity_type_media(:one)
  end

  test "should get index" do
    get activity_type_media_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_type_medium_url
    assert_response :success
  end

  test "should create activity_type_medium" do
    assert_difference('ActivityTypeMedium.count') do
      post activity_type_media_url, params: { activity_type_medium: { active_status: @activity_type_medium.active_status, activity_type_code: @activity_type_medium.activity_type_code, comment: @activity_type_medium.comment, del_status: @activity_type_medium.del_status, media_data: @activity_type_medium.media_data, media_path: @activity_type_medium.media_path, media_type: @activity_type_medium.media_type, user_id: @activity_type_medium.user_id } }
    end

    assert_redirected_to activity_type_medium_url(ActivityTypeMedium.last)
  end

  test "should show activity_type_medium" do
    get activity_type_medium_url(@activity_type_medium)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_type_medium_url(@activity_type_medium)
    assert_response :success
  end

  test "should update activity_type_medium" do
    patch activity_type_medium_url(@activity_type_medium), params: { activity_type_medium: { active_status: @activity_type_medium.active_status, activity_type_code: @activity_type_medium.activity_type_code, comment: @activity_type_medium.comment, del_status: @activity_type_medium.del_status, media_data: @activity_type_medium.media_data, media_path: @activity_type_medium.media_path, media_type: @activity_type_medium.media_type, user_id: @activity_type_medium.user_id } }
    assert_redirected_to activity_type_medium_url(@activity_type_medium)
  end

  test "should destroy activity_type_medium" do
    assert_difference('ActivityTypeMedium.count', -1) do
      delete activity_type_medium_url(@activity_type_medium)
    end

    assert_redirected_to activity_type_media_url
  end
end
