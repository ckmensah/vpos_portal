require 'test_helper'

class EntityDivSocialHandlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_div_social_handle = entity_div_social_handles(:one)
  end

  test "should get index" do
    get entity_div_social_handles_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_div_social_handle_url
    assert_response :success
  end

  test "should create entity_div_social_handle" do
    assert_difference('EntityDivSocialHandle.count') do
      post entity_div_social_handles_url, params: { entity_div_social_handle: { active_status: @entity_div_social_handle.active_status, assigned_code: @entity_div_social_handle.assigned_code, del_status: @entity_div_social_handle.del_status, entity_div_code: @entity_div_social_handle.entity_div_code, handle: @entity_div_social_handle.handle, user_id: @entity_div_social_handle.user_id } }
    end

    assert_redirected_to entity_div_social_handle_url(EntityDivSocialHandle.last)
  end

  test "should show entity_div_social_handle" do
    get entity_div_social_handle_url(@entity_div_social_handle)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_div_social_handle_url(@entity_div_social_handle)
    assert_response :success
  end

  test "should update entity_div_social_handle" do
    patch entity_div_social_handle_url(@entity_div_social_handle), params: { entity_div_social_handle: { active_status: @entity_div_social_handle.active_status, assigned_code: @entity_div_social_handle.assigned_code, del_status: @entity_div_social_handle.del_status, entity_div_code: @entity_div_social_handle.entity_div_code, handle: @entity_div_social_handle.handle, user_id: @entity_div_social_handle.user_id } }
    assert_redirected_to entity_div_social_handle_url(@entity_div_social_handle)
  end

  test "should destroy entity_div_social_handle" do
    assert_difference('EntityDivSocialHandle.count', -1) do
      delete entity_div_social_handle_url(@entity_div_social_handle)
    end

    assert_redirected_to entity_div_social_handles_url
  end
end
