require 'test_helper'

class EntityDivSubActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_div_sub_activity = entity_div_sub_activities(:one)
  end

  test "should get index" do
    get entity_div_sub_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_div_sub_activity_url
    assert_response :success
  end

  test "should create entity_div_sub_activity" do
    assert_difference('EntityDivSubActivity.count') do
      post entity_div_sub_activities_url, params: { entity_div_sub_activity: { active_status: @entity_div_sub_activity.active_status, del_status: @entity_div_sub_activity.del_status, div_sub_activity_desc: @entity_div_sub_activity.div_sub_activity_desc, entity_div_code: @entity_div_sub_activity.entity_div_code, sub_activity_code: @entity_div_sub_activity.sub_activity_code, user_id: @entity_div_sub_activity.user_id } }
    end

    assert_redirected_to entity_div_sub_activity_url(EntityDivSubActivity.last)
  end

  test "should show entity_div_sub_activity" do
    get entity_div_sub_activity_url(@entity_div_sub_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_div_sub_activity_url(@entity_div_sub_activity)
    assert_response :success
  end

  test "should update entity_div_sub_activity" do
    patch entity_div_sub_activity_url(@entity_div_sub_activity), params: { entity_div_sub_activity: { active_status: @entity_div_sub_activity.active_status, del_status: @entity_div_sub_activity.del_status, div_sub_activity_desc: @entity_div_sub_activity.div_sub_activity_desc, entity_div_code: @entity_div_sub_activity.entity_div_code, sub_activity_code: @entity_div_sub_activity.sub_activity_code, user_id: @entity_div_sub_activity.user_id } }
    assert_redirected_to entity_div_sub_activity_url(@entity_div_sub_activity)
  end

  test "should destroy entity_div_sub_activity" do
    assert_difference('EntityDivSubActivity.count', -1) do
      delete entity_div_sub_activity_url(@entity_div_sub_activity)
    end

    assert_redirected_to entity_div_sub_activities_url
  end
end
