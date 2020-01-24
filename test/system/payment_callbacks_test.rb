require "application_system_test_case"

class PaymentCallbacksTest < ApplicationSystemTestCase
  setup do
    @payment_callback = payment_callbacks(:one)
  end

  test "visiting the index" do
    visit payment_callbacks_url
    assert_selector "h1", text: "Payment Callbacks"
  end

  test "creating a Payment callback" do
    visit payment_callbacks_url
    click_on "New Payment Callback"

    check "Active status" if @payment_callback.active_status
    check "Del status" if @payment_callback.del_status
    fill_in "Nw trans", with: @payment_callback.nw_trans_id
    fill_in "Trans msg", with: @payment_callback.trans_msg
    fill_in "Trans ref", with: @payment_callback.trans_ref
    fill_in "Trans status", with: @payment_callback.trans_status
    fill_in "User", with: @payment_callback.user_id
    click_on "Create Payment callback"

    assert_text "Payment callback was successfully created"
    click_on "Back"
  end

  test "updating a Payment callback" do
    visit payment_callbacks_url
    click_on "Edit", match: :first

    check "Active status" if @payment_callback.active_status
    check "Del status" if @payment_callback.del_status
    fill_in "Nw trans", with: @payment_callback.nw_trans_id
    fill_in "Trans msg", with: @payment_callback.trans_msg
    fill_in "Trans ref", with: @payment_callback.trans_ref
    fill_in "Trans status", with: @payment_callback.trans_status
    fill_in "User", with: @payment_callback.user_id
    click_on "Update Payment callback"

    assert_text "Payment callback was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment callback" do
    visit payment_callbacks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment callback was successfully destroyed"
  end
end
