require 'test_helper'

class ActivityDivCatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_div_cat = activity_div_cats(:one)
  end

  test "should get index" do
    get activity_div_cats_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_div_cat_url
    assert_response :success
  end

  test "should create activity_div_cat" do
    assert_difference('ActivityDivCat.count') do
      post activity_div_cats_url, params: { activity_div_cat: { active_status: @activity_div_cat.active_status, comment: @activity_div_cat.comment, del_status: @activity_div_cat.del_status, div_cat_desc: @activity_div_cat.div_cat_desc, division_code: @activity_div_cat.division_code, user_id: @activity_div_cat.user_id } }
    end

    assert_redirected_to activity_div_cat_url(ActivityDivCat.last)
  end

  test "should show activity_div_cat" do
    get activity_div_cat_url(@activity_div_cat)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_div_cat_url(@activity_div_cat)
    assert_response :success
  end

  test "should update activity_div_cat" do
    patch activity_div_cat_url(@activity_div_cat), params: { activity_div_cat: { active_status: @activity_div_cat.active_status, comment: @activity_div_cat.comment, del_status: @activity_div_cat.del_status, div_cat_desc: @activity_div_cat.div_cat_desc, division_code: @activity_div_cat.division_code, user_id: @activity_div_cat.user_id } }
    assert_redirected_to activity_div_cat_url(@activity_div_cat)
  end

  test "should destroy activity_div_cat" do
    assert_difference('ActivityDivCat.count', -1) do
      delete activity_div_cat_url(@activity_div_cat)
    end

    assert_redirected_to activity_div_cats_url
  end
end
