require "application_system_test_case"

class PaymentInfosTest < ApplicationSystemTestCase
  setup do
    @payment_info = payment_infos(:one)
  end

  test "visiting the index" do
    visit payment_infos_url
    assert_selector "h1", text: "Payment Infos"
  end

  test "creating a Payment info" do
    visit payment_infos_url
    click_on "New Payment Info"

    check "Active status" if @payment_info.active_status
    fill_in "Activity div", with: @payment_info.activity_div_id
    fill_in "Activity lov", with: @payment_info.activity_lov_id
    fill_in "Activity sub div", with: @payment_info.activity_sub_div_id
    fill_in "Amount", with: @payment_info.amount
    fill_in "Charge", with: @payment_info.charge
    fill_in "Customer number", with: @payment_info.customer_number
    check "Del status" if @payment_info.del_status
    fill_in "Entity div code", with: @payment_info.entity_div_code
    fill_in "Payment mode", with: @payment_info.payment_mode
    check "Processed" if @payment_info.processed
    fill_in "Session", with: @payment_info.session_id
    fill_in "Src", with: @payment_info.src
    fill_in "Trans type", with: @payment_info.trans_type
    fill_in "User", with: @payment_info.user_id
    click_on "Create Payment info"

    assert_text "Payment info was successfully created"
    click_on "Back"
  end

  test "updating a Payment info" do
    visit payment_infos_url
    click_on "Edit", match: :first

    check "Active status" if @payment_info.active_status
    fill_in "Activity div", with: @payment_info.activity_div_id
    fill_in "Activity lov", with: @payment_info.activity_lov_id
    fill_in "Activity sub div", with: @payment_info.activity_sub_div_id
    fill_in "Amount", with: @payment_info.amount
    fill_in "Charge", with: @payment_info.charge
    fill_in "Customer number", with: @payment_info.customer_number
    check "Del status" if @payment_info.del_status
    fill_in "Entity div code", with: @payment_info.entity_div_code
    fill_in "Payment mode", with: @payment_info.payment_mode
    check "Processed" if @payment_info.processed
    fill_in "Session", with: @payment_info.session_id
    fill_in "Src", with: @payment_info.src
    fill_in "Trans type", with: @payment_info.trans_type
    fill_in "User", with: @payment_info.user_id
    click_on "Update Payment info"

    assert_text "Payment info was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment info" do
    visit payment_infos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment info was successfully destroyed"
  end
end
