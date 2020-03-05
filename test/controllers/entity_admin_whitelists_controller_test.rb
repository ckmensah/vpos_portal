require 'test_helper'

class EntityAdminWhitelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_admin_whitelist = entity_admin_whitelists(:one)
  end

  test "should get index" do
    get entity_admin_whitelists_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_admin_whitelist_url
    assert_response :success
  end

  test "should create entity_admin_whitelist" do
    assert_difference('EntityAdminWhitelist.count') do
      post entity_admin_whitelists_url, params: { entity_admin_whitelist: { active_status: @entity_admin_whitelist.active_status, del_status: @entity_admin_whitelist.del_status, entity_division_code: @entity_admin_whitelist.entity_division_code, full_name: @entity_admin_whitelist.full_name, mobile_number: @entity_admin_whitelist.mobile_number, user_id: @entity_admin_whitelist.user_id } }
    end

    assert_redirected_to entity_admin_whitelist_url(EntityAdminWhitelist.last)
  end

  test "should show entity_admin_whitelist" do
    get entity_admin_whitelist_url(@entity_admin_whitelist)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_admin_whitelist_url(@entity_admin_whitelist)
    assert_response :success
  end

  test "should update entity_admin_whitelist" do
    patch entity_admin_whitelist_url(@entity_admin_whitelist), params: { entity_admin_whitelist: { active_status: @entity_admin_whitelist.active_status, del_status: @entity_admin_whitelist.del_status, entity_division_code: @entity_admin_whitelist.entity_division_code, full_name: @entity_admin_whitelist.full_name, mobile_number: @entity_admin_whitelist.mobile_number, user_id: @entity_admin_whitelist.user_id } }
    assert_redirected_to entity_admin_whitelist_url(@entity_admin_whitelist)
  end

  test "should destroy entity_admin_whitelist" do
    assert_difference('EntityAdminWhitelist.count', -1) do
      delete entity_admin_whitelist_url(@entity_admin_whitelist)
    end

    assert_redirected_to entity_admin_whitelists_url
  end
end
