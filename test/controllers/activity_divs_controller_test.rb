require 'test_helper'

class ActivityDivsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_div = activity_divs(:one)
  end

  test "should get index" do
    get activity_divs_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_div_url
    assert_response :success
  end

  test "should create activity_div" do
    assert_difference('ActivityDiv.count') do
      post activity_divs_url, params: { activity_div: { active_status: @activity_div.active_status, activity_date: @activity_div.activity_date, comment: @activity_div.comment, del_status: @activity_div.del_status, division_code: @activity_div.division_code, user_id: @activity_div.user_id } }
    end

    assert_redirected_to activity_div_url(ActivityDiv.last)
  end

  test "should show activity_div" do
    get activity_div_url(@activity_div)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_div_url(@activity_div)
    assert_response :success
  end

  test "should update activity_div" do
    patch activity_div_url(@activity_div), params: { activity_div: { active_status: @activity_div.active_status, activity_date: @activity_div.activity_date, comment: @activity_div.comment, del_status: @activity_div.del_status, division_code: @activity_div.division_code, user_id: @activity_div.user_id } }
    assert_redirected_to activity_div_url(@activity_div)
  end

  test "should destroy activity_div" do
    assert_difference('ActivityDiv.count', -1) do
      delete activity_div_url(@activity_div)
    end

    assert_redirected_to activity_divs_url
  end
end
