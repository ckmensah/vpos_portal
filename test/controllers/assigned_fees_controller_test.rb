require 'test_helper'

class AssignedFeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assigned_fee = assigned_fees(:one)
  end

  test "should get index" do
    get assigned_fees_url
    assert_response :success
  end

  test "should get new" do
    get new_assigned_fee_url
    assert_response :success
  end

  test "should create assigned_fee" do
    assert_difference('AssignedFee.count') do
      post assigned_fees_url, params: { assigned_fee: { active_status: @assigned_fee.active_status, cap: @assigned_fee.cap, charged_to: @assigned_fee.charged_to, comment: @assigned_fee.comment, del_status: @assigned_fee.del_status, entity_div_code: @assigned_fee.entity_div_code, fee: @assigned_fee.fee, flat_percent: @assigned_fee.flat_percent, limit_capped: @assigned_fee.limit_capped, trans_type: @assigned_fee.trans_type, user_id: @assigned_fee.user_id } }
    end

    assert_redirected_to assigned_fee_url(AssignedFee.last)
  end

  test "should show assigned_fee" do
    get assigned_fee_url(@assigned_fee)
    assert_response :success
  end

  test "should get edit" do
    get edit_assigned_fee_url(@assigned_fee)
    assert_response :success
  end

  test "should update assigned_fee" do
    patch assigned_fee_url(@assigned_fee), params: { assigned_fee: { active_status: @assigned_fee.active_status, cap: @assigned_fee.cap, charged_to: @assigned_fee.charged_to, comment: @assigned_fee.comment, del_status: @assigned_fee.del_status, entity_div_code: @assigned_fee.entity_div_code, fee: @assigned_fee.fee, flat_percent: @assigned_fee.flat_percent, limit_capped: @assigned_fee.limit_capped, trans_type: @assigned_fee.trans_type, user_id: @assigned_fee.user_id } }
    assert_redirected_to assigned_fee_url(@assigned_fee)
  end

  test "should destroy assigned_fee" do
    assert_difference('AssignedFee.count', -1) do
      delete assigned_fee_url(@assigned_fee)
    end

    assert_redirected_to assigned_fees_url
  end
end
