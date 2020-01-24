require 'test_helper'

class PaymentInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_info = payment_infos(:one)
  end

  test "should get index" do
    get payment_infos_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_info_url
    assert_response :success
  end

  test "should create payment_info" do
    assert_difference('PaymentInfo.count') do
      post payment_infos_url, params: { payment_info: { active_status: @payment_info.active_status, activity_div_id: @payment_info.activity_div_id, activity_lov_id: @payment_info.activity_lov_id, activity_sub_div_id: @payment_info.activity_sub_div_id, amount: @payment_info.amount, charge: @payment_info.charge, customer_number: @payment_info.customer_number, del_status: @payment_info.del_status, entity_div_code: @payment_info.entity_div_code, payment_mode: @payment_info.payment_mode, processed: @payment_info.processed, session_id: @payment_info.session_id, src: @payment_info.src, trans_type: @payment_info.trans_type, user_id: @payment_info.user_id } }
    end

    assert_redirected_to payment_info_url(PaymentInfo.last)
  end

  test "should show payment_info" do
    get payment_info_url(@payment_info)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_info_url(@payment_info)
    assert_response :success
  end

  test "should update payment_info" do
    patch payment_info_url(@payment_info), params: { payment_info: { active_status: @payment_info.active_status, activity_div_id: @payment_info.activity_div_id, activity_lov_id: @payment_info.activity_lov_id, activity_sub_div_id: @payment_info.activity_sub_div_id, amount: @payment_info.amount, charge: @payment_info.charge, customer_number: @payment_info.customer_number, del_status: @payment_info.del_status, entity_div_code: @payment_info.entity_div_code, payment_mode: @payment_info.payment_mode, processed: @payment_info.processed, session_id: @payment_info.session_id, src: @payment_info.src, trans_type: @payment_info.trans_type, user_id: @payment_info.user_id } }
    assert_redirected_to payment_info_url(@payment_info)
  end

  test "should destroy payment_info" do
    assert_difference('PaymentInfo.count', -1) do
      delete payment_info_url(@payment_info)
    end

    assert_redirected_to payment_infos_url
  end
end
