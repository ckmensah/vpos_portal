require "application_system_test_case"

class LoanRequestsTest < ApplicationSystemTestCase
  setup do
    @loan_request = loan_requests(:one)
  end

  test "visiting the index" do
    visit loan_requests_url
    assert_selector "h1", text: "Loan Requests"
  end

  test "creating a Loan request" do
    visit loan_requests_url
    click_on "New Loan Request"

    check "Active status" if @loan_request.active_status
    fill_in "Amount", with: @loan_request.amount
    fill_in "Comment", with: @loan_request.comment
    check "Del status" if @loan_request.del_status
    fill_in "Full name", with: @loan_request.full_name
    fill_in "Id number", with: @loan_request.id_number
    fill_in "Location", with: @loan_request.location
    fill_in "Ref number", with: @loan_request.ref_number
    fill_in "User", with: @loan_request.user_id
    click_on "Create Loan request"

    assert_text "Loan request was successfully created"
    click_on "Back"
  end

  test "updating a Loan request" do
    visit loan_requests_url
    click_on "Edit", match: :first

    check "Active status" if @loan_request.active_status
    fill_in "Amount", with: @loan_request.amount
    fill_in "Comment", with: @loan_request.comment
    check "Del status" if @loan_request.del_status
    fill_in "Full name", with: @loan_request.full_name
    fill_in "Id number", with: @loan_request.id_number
    fill_in "Location", with: @loan_request.location
    fill_in "Ref number", with: @loan_request.ref_number
    fill_in "User", with: @loan_request.user_id
    click_on "Update Loan request"

    assert_text "Loan request was successfully updated"
    click_on "Back"
  end

  test "destroying a Loan request" do
    visit loan_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Loan request was successfully destroyed"
  end
end
