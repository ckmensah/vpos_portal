require 'test_helper'

class LoanRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan_request = loan_requests(:one)
  end

  test "should get index" do
    get loan_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_request_url
    assert_response :success
  end

  test "should create loan_request" do
    assert_difference('LoanRequest.count') do
      post loan_requests_url, params: { loan_request: { active_status: @loan_request.active_status, amount: @loan_request.amount, comment: @loan_request.comment, del_status: @loan_request.del_status, full_name: @loan_request.full_name, id_number: @loan_request.id_number, location: @loan_request.location, ref_number: @loan_request.ref_number, user_id: @loan_request.user_id } }
    end

    assert_redirected_to loan_request_url(LoanRequest.last)
  end

  test "should show loan_request" do
    get loan_request_url(@loan_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_request_url(@loan_request)
    assert_response :success
  end

  test "should update loan_request" do
    patch loan_request_url(@loan_request), params: { loan_request: { active_status: @loan_request.active_status, amount: @loan_request.amount, comment: @loan_request.comment, del_status: @loan_request.del_status, full_name: @loan_request.full_name, id_number: @loan_request.id_number, location: @loan_request.location, ref_number: @loan_request.ref_number, user_id: @loan_request.user_id } }
    assert_redirected_to loan_request_url(@loan_request)
  end

  test "should destroy loan_request" do
    assert_difference('LoanRequest.count', -1) do
      delete loan_request_url(@loan_request)
    end

    assert_redirected_to loan_requests_url
  end
end
