require 'test_helper'

class ActivityCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_category = activity_categories(:one)
  end

  test "should get index" do
    get activity_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_category_url
    assert_response :success
  end

  test "should create activity_category" do
    assert_difference('ActivityCategory.count') do
      post activity_categories_url, params: { activity_category: { active_status: @activity_category.active_status, activity_cat_desc: @activity_category.activity_cat_desc, assigned_code: @activity_category.assigned_code, comment: @activity_category.comment, del_status: @activity_category.del_status, image_data: @activity_category.image_data, image_path: @activity_category.image_path, user_id: @activity_category.user_id } }
    end

    assert_redirected_to activity_category_url(ActivityCategory.last)
  end

  test "should show activity_category" do
    get activity_category_url(@activity_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_category_url(@activity_category)
    assert_response :success
  end

  test "should update activity_category" do
    patch activity_category_url(@activity_category), params: { activity_category: { active_status: @activity_category.active_status, activity_cat_desc: @activity_category.activity_cat_desc, assigned_code: @activity_category.assigned_code, comment: @activity_category.comment, del_status: @activity_category.del_status, image_data: @activity_category.image_data, image_path: @activity_category.image_path, user_id: @activity_category.user_id } }
    assert_redirected_to activity_category_url(@activity_category)
  end

  test "should destroy activity_category" do
    assert_difference('ActivityCategory.count', -1) do
      delete activity_category_url(@activity_category)
    end

    assert_redirected_to activity_categories_url
  end
end
