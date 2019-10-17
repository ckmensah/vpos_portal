require 'test_helper'

class ActivitySubDivsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_sub_div = activity_sub_divs(:one)
  end

  test "should get index" do
    get activity_sub_divs_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_sub_div_url
    assert_response :success
  end

  test "should create activity_sub_div" do
    assert_difference('ActivitySubDiv.count') do
      post activity_sub_divs_url, params: { activity_sub_div: { active_status: @activity_sub_div.active_status, activity_div_id: @activity_sub_div.activity_div_id, activity_time: @activity_sub_div.activity_time, amount: @activity_sub_div.amount, classification: @activity_sub_div.classification, comment: @activity_sub_div.comment, del_status: @activity_sub_div.del_status, user_id: @activity_sub_div.user_id } }
    end

    assert_redirected_to activity_sub_div_url(ActivitySubDiv.last)
  end

  test "should show activity_sub_div" do
    get activity_sub_div_url(@activity_sub_div)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_sub_div_url(@activity_sub_div)
    assert_response :success
  end

  test "should update activity_sub_div" do
    patch activity_sub_div_url(@activity_sub_div), params: { activity_sub_div: { active_status: @activity_sub_div.active_status, activity_div_id: @activity_sub_div.activity_div_id, activity_time: @activity_sub_div.activity_time, amount: @activity_sub_div.amount, classification: @activity_sub_div.classification, comment: @activity_sub_div.comment, del_status: @activity_sub_div.del_status, user_id: @activity_sub_div.user_id } }
    assert_redirected_to activity_sub_div_url(@activity_sub_div)
  end

  test "should destroy activity_sub_div" do
    assert_difference('ActivitySubDiv.count', -1) do
      delete activity_sub_div_url(@activity_sub_div)
    end

    assert_redirected_to activity_sub_divs_url
  end
end
