require 'test_helper'

class ActivityCategoryDivsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_category_div = activity_category_divs(:one)
  end

  test "should get index" do
    get activity_category_divs_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_category_div_url
    assert_response :success
  end

  test "should create activity_category_div" do
    assert_difference('ActivityCategoryDiv.count') do
      post activity_category_divs_url, params: { activity_category_div: { active_status: @activity_category_div.active_status, activity_category_id: @activity_category_div.activity_category_id, activity_div_cat_id: @activity_category_div.activity_div_cat_id, category_div_desc: @activity_category_div.category_div_desc, comment: @activity_category_div.comment, del_status: @activity_category_div.del_status, division_code: @activity_category_div.division_code, user_id: @activity_category_div.user_id } }
    end

    assert_redirected_to activity_category_div_url(ActivityCategoryDiv.last)
  end

  test "should show activity_category_div" do
    get activity_category_div_url(@activity_category_div)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_category_div_url(@activity_category_div)
    assert_response :success
  end

  test "should update activity_category_div" do
    patch activity_category_div_url(@activity_category_div), params: { activity_category_div: { active_status: @activity_category_div.active_status, activity_category_id: @activity_category_div.activity_category_id, activity_div_cat_id: @activity_category_div.activity_div_cat_id, category_div_desc: @activity_category_div.category_div_desc, comment: @activity_category_div.comment, del_status: @activity_category_div.del_status, division_code: @activity_category_div.division_code, user_id: @activity_category_div.user_id } }
    assert_redirected_to activity_category_div_url(@activity_category_div)
  end

  test "should destroy activity_category_div" do
    assert_difference('ActivityCategoryDiv.count', -1) do
      delete activity_category_div_url(@activity_category_div)
    end

    assert_redirected_to activity_category_divs_url
  end
end
