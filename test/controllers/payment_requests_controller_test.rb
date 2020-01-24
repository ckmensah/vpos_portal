require 'test_helper'

class PaymentRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_request = payment_requests(:one)
  end

  test "should get index" do
    get payment_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_request_url
    assert_response :success
  end

  test "should create payment_request" do
    assert_difference('PaymentRequest.count') do
      post payment_requests_url, params: { payment_request: { active_status: @payment_request.active_status, amount: @payment_request.amount, customer_number: @payment_request.customer_number, del_status: @payment_request.del_status, nw: @payment_request.nw, payment_info_id: @payment_request.payment_info_id, payment_mode: @payment_request.payment_mode, processed: @payment_request.processed, processing_id: @payment_request.processing_id, reference: @payment_request.reference, service_id: @payment_request.service_id, trans_type: @payment_request.trans_type, user_id: @payment_request.user_id } }
    end

    assert_redirected_to payment_request_url(PaymentRequest.last)
  end

  test "should show payment_request" do
    get payment_request_url(@payment_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_request_url(@payment_request)
    assert_response :success
  end

  test "should update payment_request" do
    patch payment_request_url(@payment_request), params: { payment_request: { active_status: @payment_request.active_status, amount: @payment_request.amount, customer_number: @payment_request.customer_number, del_status: @payment_request.del_status, nw: @payment_request.nw, payment_info_id: @payment_request.payment_info_id, payment_mode: @payment_request.payment_mode, processed: @payment_request.processed, processing_id: @payment_request.processing_id, reference: @payment_request.reference, service_id: @payment_request.service_id, trans_type: @payment_request.trans_type, user_id: @payment_request.user_id } }
    assert_redirected_to payment_request_url(@payment_request)
  end

  test "should destroy payment_request" do
    assert_difference('PaymentRequest.count', -1) do
      delete payment_request_url(@payment_request)
    end

    assert_redirected_to payment_requests_url
  end
end
