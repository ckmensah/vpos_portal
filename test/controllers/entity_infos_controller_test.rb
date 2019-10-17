require 'test_helper'

class EntityInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_info = entity_infos(:one)
  end

  test "should get index" do
    get entity_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_info_url
    assert_response :success
  end

  test "should create entity_info" do
    assert_difference('EntityInfo.count') do
      post entity_infos_url, params: { entity_info: { active_status: @entity_info.active_status, assigned_code: @entity_info.assigned_code, comment: @entity_info.comment, del_status: @entity_info.del_status, entity_alias: @entity_info.entity_alias, entity_cat_id: @entity_info.entity_cat_id, entity_name: @entity_info.entity_name, user_id: @entity_info.user_id } }
    end

    assert_redirected_to entity_info_url(EntityInfo.last)
  end

  test "should show entity_info" do
    get entity_info_url(@entity_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_info_url(@entity_info)
    assert_response :success
  end

  test "should update entity_info" do
    patch entity_info_url(@entity_info), params: { entity_info: { active_status: @entity_info.active_status, assigned_code: @entity_info.assigned_code, comment: @entity_info.comment, del_status: @entity_info.del_status, entity_alias: @entity_info.entity_alias, entity_cat_id: @entity_info.entity_cat_id, entity_name: @entity_info.entity_name, user_id: @entity_info.user_id } }
    assert_redirected_to entity_info_url(@entity_info)
  end

  test "should destroy entity_info" do
    assert_difference('EntityInfo.count', -1) do
      delete entity_info_url(@entity_info)
    end

    assert_redirected_to entity_infos_url
  end
end
