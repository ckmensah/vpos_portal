require "application_system_test_case"

class PaymentRequestsTest < ApplicationSystemTestCase
  setup do
    @payment_request = payment_requests(:one)
  end

  test "visiting the index" do
    visit payment_requests_url
    assert_selector "h1", text: "Payment Requests"
  end

  test "creating a Payment request" do
    visit payment_requests_url
    click_on "New Payment Request"

    check "Active status" if @payment_request.active_status
    fill_in "Amount", with: @payment_request.amount
    fill_in "Customer number", with: @payment_request.customer_number
    check "Del status" if @payment_request.del_status
    fill_in "Nw", with: @payment_request.nw
    fill_in "Payment info", with: @payment_request.payment_info_id
    fill_in "Payment mode", with: @payment_request.payment_mode
    check "Processed" if @payment_request.processed
    fill_in "Processing", with: @payment_request.processing_id
    fill_in "Reference", with: @payment_request.reference
    fill_in "Service", with: @payment_request.service_id
    fill_in "Trans type", with: @payment_request.trans_type
    fill_in "User", with: @payment_request.user_id
    click_on "Create Payment request"

    assert_text "Payment request was successfully created"
    click_on "Back"
  end

  test "updating a Payment request" do
    visit payment_requests_url
    click_on "Edit", match: :first

    check "Active status" if @payment_request.active_status
    fill_in "Amount", with: @payment_request.amount
    fill_in "Customer number", with: @payment_request.customer_number
    check "Del status" if @payment_request.del_status
    fill_in "Nw", with: @payment_request.nw
    fill_in "Payment info", with: @payment_request.payment_info_id
    fill_in "Payment mode", with: @payment_request.payment_mode
    check "Processed" if @payment_request.processed
    fill_in "Processing", with: @payment_request.processing_id
    fill_in "Reference", with: @payment_request.reference
    fill_in "Service", with: @payment_request.service_id
    fill_in "Trans type", with: @payment_request.trans_type
    fill_in "User", with: @payment_request.user_id
    click_on "Update Payment request"

    assert_text "Payment request was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment request" do
    visit payment_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment request was successfully destroyed"
  end
end
