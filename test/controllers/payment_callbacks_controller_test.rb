require 'test_helper'

class PaymentCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_callback = payment_callbacks(:one)
  end

  test "should get index" do
    get payment_callbacks_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_callback_url
    assert_response :success
  end

  test "should create payment_callback" do
    assert_difference('PaymentCallback.count') do
      post payment_callbacks_url, params: { payment_callback: { active_status: @payment_callback.active_status, del_status: @payment_callback.del_status, nw_trans_id: @payment_callback.nw_trans_id, trans_msg: @payment_callback.trans_msg, trans_ref: @payment_callback.trans_ref, trans_status: @payment_callback.trans_status, user_id: @payment_callback.user_id } }
    end

    assert_redirected_to payment_callback_url(PaymentCallback.last)
  end

  test "should show payment_callback" do
    get payment_callback_url(@payment_callback)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_callback_url(@payment_callback)
    assert_response :success
  end

  test "should update payment_callback" do
    patch payment_callback_url(@payment_callback), params: { payment_callback: { active_status: @payment_callback.active_status, del_status: @payment_callback.del_status, nw_trans_id: @payment_callback.nw_trans_id, trans_msg: @payment_callback.trans_msg, trans_ref: @payment_callback.trans_ref, trans_status: @payment_callback.trans_status, user_id: @payment_callback.user_id } }
    assert_redirected_to payment_callback_url(@payment_callback)
  end

  test "should destroy payment_callback" do
    assert_difference('PaymentCallback.count', -1) do
      delete payment_callback_url(@payment_callback)
    end

    assert_redirected_to payment_callbacks_url
  end
end
