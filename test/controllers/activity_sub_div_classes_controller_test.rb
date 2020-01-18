require 'test_helper'

class ActivitySubDivClassesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_sub_div_class = activity_sub_div_classes(:one)
  end

  test "should get index" do
    get activity_sub_div_classes_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_sub_div_class_url
    assert_response :success
  end

  test "should create activity_sub_div_class" do
    assert_difference('ActivitySubDivClass.count') do
      post activity_sub_div_classes_url, params: { activity_sub_div_class: { active_status: @activity_sub_div_class.active_status, class_desc: @activity_sub_div_class.class_desc, comment: @activity_sub_div_class.comment, del_status: @activity_sub_div_class.del_status, entity_div_code: @activity_sub_div_class.entity_div_code, user_id: @activity_sub_div_class.user_id } }
    end

    assert_redirected_to activity_sub_div_class_url(ActivitySubDivClass.last)
  end

  test "should show activity_sub_div_class" do
    get activity_sub_div_class_url(@activity_sub_div_class)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_sub_div_class_url(@activity_sub_div_class)
    assert_response :success
  end

  test "should update activity_sub_div_class" do
    patch activity_sub_div_class_url(@activity_sub_div_class), params: { activity_sub_div_class: { active_status: @activity_sub_div_class.active_status, class_desc: @activity_sub_div_class.class_desc, comment: @activity_sub_div_class.comment, del_status: @activity_sub_div_class.del_status, entity_div_code: @activity_sub_div_class.entity_div_code, user_id: @activity_sub_div_class.user_id } }
    assert_redirected_to activity_sub_div_class_url(@activity_sub_div_class)
  end

  test "should destroy activity_sub_div_class" do
    assert_difference('ActivitySubDivClass.count', -1) do
      delete activity_sub_div_class_url(@activity_sub_div_class)
    end

    assert_redirected_to activity_sub_div_classes_url
  end
end
