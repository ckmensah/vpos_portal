require "application_system_test_case"

class EntityDivAlertRecipientsTest < ApplicationSystemTestCase
  setup do
    @entity_div_alert_recipient = entity_div_alert_recipients(:one)
  end

  test "visiting the index" do
    visit entity_div_alert_recipients_url
    assert_selector "h1", text: "Entity Div Alert Recipients"
  end

  test "creating a Entity div alert recipient" do
    visit entity_div_alert_recipients_url
    click_on "New Entity Div Alert Recipient"

    check "Active status" if @entity_div_alert_recipient.active_status
    check "Del status" if @entity_div_alert_recipient.del_status
    fill_in "Entity div code", with: @entity_div_alert_recipient.entity_div_code
    fill_in "Mobile number", with: @entity_div_alert_recipient.mobile_number
    fill_in "Recipient name", with: @entity_div_alert_recipient.recipient_name
    fill_in "User", with: @entity_div_alert_recipient.user_id
    click_on "Create Entity div alert recipient"

    assert_text "Entity div alert recipient was successfully created"
    click_on "Back"
  end

  test "updating a Entity div alert recipient" do
    visit entity_div_alert_recipients_url
    click_on "Edit", match: :first

    check "Active status" if @entity_div_alert_recipient.active_status
    check "Del status" if @entity_div_alert_recipient.del_status
    fill_in "Entity div code", with: @entity_div_alert_recipient.entity_div_code
    fill_in "Mobile number", with: @entity_div_alert_recipient.mobile_number
    fill_in "Recipient name", with: @entity_div_alert_recipient.recipient_name
    fill_in "User", with: @entity_div_alert_recipient.user_id
    click_on "Update Entity div alert recipient"

    assert_text "Entity div alert recipient was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity div alert recipient" do
    visit entity_div_alert_recipients_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity div alert recipient was successfully destroyed"
  end
end
