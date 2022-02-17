require 'test_helper'

class MultiUserRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @multi_user_role = multi_user_roles(:one)
  end

  test "should get index" do
    get multi_user_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_multi_user_role_url
    assert_response :success
  end

  test "should create multi_user_role" do
    assert_difference('MultiUserRole.count') do
      post multi_user_roles_url, params: { multi_user_role: { active_status: @multi_user_role.active_status, comment: @multi_user_role.comment, creator_id: @multi_user_role.creator_id, del_status: @multi_user_role.del_status, entity_code: @multi_user_role.entity_code, role_code: @multi_user_role.role_code, user_id: @multi_user_role.user_id } }
    end

    assert_redirected_to multi_user_role_url(MultiUserRole.last)
  end

  test "should show multi_user_role" do
    get multi_user_role_url(@multi_user_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_multi_user_role_url(@multi_user_role)
    assert_response :success
  end

  test "should update multi_user_role" do
    patch multi_user_role_url(@multi_user_role), params: { multi_user_role: { active_status: @multi_user_role.active_status, comment: @multi_user_role.comment, creator_id: @multi_user_role.creator_id, del_status: @multi_user_role.del_status, entity_code: @multi_user_role.entity_code, role_code: @multi_user_role.role_code, user_id: @multi_user_role.user_id } }
    assert_redirected_to multi_user_role_url(@multi_user_role)
  end

  test "should destroy multi_user_role" do
    assert_difference('MultiUserRole.count', -1) do
      delete multi_user_role_url(@multi_user_role)
    end

    assert_redirected_to multi_user_roles_url
  end
end
