require 'test_helper'

class EntityServiceAccountTrxnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_service_account_trxn = entity_service_account_trxns(:one)
  end

  test "should get index" do
    get entity_service_account_trxns_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_service_account_trxn_url
    assert_response :success
  end

  test "should create entity_service_account_trxn" do
    assert_difference('EntityServiceAccountTrxn.count') do
      post entity_service_account_trxns_url, params: { entity_service_account_trxn: { active_status: @entity_service_account_trxn.active_status, charge: @entity_service_account_trxn.charge, comment: @entity_service_account_trxn.comment, del_status: @entity_service_account_trxn.del_status, entity_div_code: @entity_service_account_trxn.entity_div_code, gross_bal_aft: @entity_service_account_trxn.gross_bal_aft, gross_bal_bef: @entity_service_account_trxn.gross_bal_bef, net_bal_aft: @entity_service_account_trxn.net_bal_aft, net_bal_bef: @entity_service_account_trxn.net_bal_bef, processing_id: @entity_service_account_trxn.processing_id, trans_type: @entity_service_account_trxn.trans_type, user_id: @entity_service_account_trxn.user_id } }
    end

    assert_redirected_to entity_service_account_trxn_url(EntityServiceAccountTrxn.last)
  end

  test "should show entity_service_account_trxn" do
    get entity_service_account_trxn_url(@entity_service_account_trxn)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_service_account_trxn_url(@entity_service_account_trxn)
    assert_response :success
  end

  test "should update entity_service_account_trxn" do
    patch entity_service_account_trxn_url(@entity_service_account_trxn), params: { entity_service_account_trxn: { active_status: @entity_service_account_trxn.active_status, charge: @entity_service_account_trxn.charge, comment: @entity_service_account_trxn.comment, del_status: @entity_service_account_trxn.del_status, entity_div_code: @entity_service_account_trxn.entity_div_code, gross_bal_aft: @entity_service_account_trxn.gross_bal_aft, gross_bal_bef: @entity_service_account_trxn.gross_bal_bef, net_bal_aft: @entity_service_account_trxn.net_bal_aft, net_bal_bef: @entity_service_account_trxn.net_bal_bef, processing_id: @entity_service_account_trxn.processing_id, trans_type: @entity_service_account_trxn.trans_type, user_id: @entity_service_account_trxn.user_id } }
    assert_redirected_to entity_service_account_trxn_url(@entity_service_account_trxn)
  end

  test "should destroy entity_service_account_trxn" do
    assert_difference('EntityServiceAccountTrxn.count', -1) do
      delete entity_service_account_trxn_url(@entity_service_account_trxn)
    end

    assert_redirected_to entity_service_account_trxns_url
  end
end
