require 'test_helper'

class FundMovementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fund_movement = fund_movements(:one)
  end

  test "should get index" do
    get fund_movements_url
    assert_response :success
  end

  test "should get new" do
    get new_fund_movement_url
    assert_response :success
  end

  test "should create fund_movement" do
    assert_difference('FundMovement.count') do
      post fund_movements_url, params: { fund_movement: { amount: @fund_movement.amount, entity_div_code: @fund_movement.entity_div_code, narration: @fund_movement.narration, processed: @fund_movement.processed, ref_id: @fund_movement.ref_id, service_id: @fund_movement.service_id, trans_desc: @fund_movement.trans_desc, trans_status: @fund_movement.trans_status, trans_type: @fund_movement.trans_type } }
    end

    assert_redirected_to fund_movement_url(FundMovement.last)
  end

  test "should show fund_movement" do
    get fund_movement_url(@fund_movement)
    assert_response :success
  end

  test "should get edit" do
    get edit_fund_movement_url(@fund_movement)
    assert_response :success
  end

  test "should update fund_movement" do
    patch fund_movement_url(@fund_movement), params: { fund_movement: { amount: @fund_movement.amount, entity_div_code: @fund_movement.entity_div_code, narration: @fund_movement.narration, processed: @fund_movement.processed, ref_id: @fund_movement.ref_id, service_id: @fund_movement.service_id, trans_desc: @fund_movement.trans_desc, trans_status: @fund_movement.trans_status, trans_type: @fund_movement.trans_type } }
    assert_redirected_to fund_movement_url(@fund_movement)
  end

  test "should destroy fund_movement" do
    assert_difference('FundMovement.count', -1) do
      delete fund_movement_url(@fund_movement)
    end

    assert_redirected_to fund_movements_url
  end
end
