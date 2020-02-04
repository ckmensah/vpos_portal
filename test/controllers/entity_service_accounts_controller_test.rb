require 'test_helper'

class EntityServiceAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_service_account = entity_service_accounts(:one)
  end

  test "should get index" do
    get entity_service_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_service_account_url
    assert_response :success
  end

  test "should create entity_service_account" do
    assert_difference('EntityServiceAccount.count') do
      post entity_service_accounts_url, params: { entity_service_account: { active_status: @entity_service_account.active_status, comment: @entity_service_account.comment, del_status: @entity_service_account.del_status, entity_div_code: @entity_service_account.entity_div_code, gross_bal: @entity_service_account.gross_bal, net_bal: @entity_service_account.net_bal, user_id: @entity_service_account.user_id } }
    end

    assert_redirected_to entity_service_account_url(EntityServiceAccount.last)
  end

  test "should show entity_service_account" do
    get entity_service_account_url(@entity_service_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_service_account_url(@entity_service_account)
    assert_response :success
  end

  test "should update entity_service_account" do
    patch entity_service_account_url(@entity_service_account), params: { entity_service_account: { active_status: @entity_service_account.active_status, comment: @entity_service_account.comment, del_status: @entity_service_account.del_status, entity_div_code: @entity_service_account.entity_div_code, gross_bal: @entity_service_account.gross_bal, net_bal: @entity_service_account.net_bal, user_id: @entity_service_account.user_id } }
    assert_redirected_to entity_service_account_url(@entity_service_account)
  end

  test "should destroy entity_service_account" do
    assert_difference('EntityServiceAccount.count', -1) do
      delete entity_service_account_url(@entity_service_account)
    end

    assert_redirected_to entity_service_accounts_url
  end
end
