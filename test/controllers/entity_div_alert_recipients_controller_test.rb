require 'test_helper'

class EntityDivAlertRecipientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_div_alert_recipient = entity_div_alert_recipients(:one)
  end

  test "should get index" do
    get entity_div_alert_recipients_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_div_alert_recipient_url
    assert_response :success
  end

  test "should create entity_div_alert_recipient" do
    assert_difference('EntityDivAlertRecipient.count') do
      post entity_div_alert_recipients_url, params: { entity_div_alert_recipient: { active_status: @entity_div_alert_recipient.active_status, del_status: @entity_div_alert_recipient.del_status, entity_div_code: @entity_div_alert_recipient.entity_div_code, mobile_number: @entity_div_alert_recipient.mobile_number, recipient_name: @entity_div_alert_recipient.recipient_name, user_id: @entity_div_alert_recipient.user_id } }
    end

    assert_redirected_to entity_div_alert_recipient_url(EntityDivAlertRecipient.last)
  end

  test "should show entity_div_alert_recipient" do
    get entity_div_alert_recipient_url(@entity_div_alert_recipient)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_div_alert_recipient_url(@entity_div_alert_recipient)
    assert_response :success
  end

  test "should update entity_div_alert_recipient" do
    patch entity_div_alert_recipient_url(@entity_div_alert_recipient), params: { entity_div_alert_recipient: { active_status: @entity_div_alert_recipient.active_status, del_status: @entity_div_alert_recipient.del_status, entity_div_code: @entity_div_alert_recipient.entity_div_code, mobile_number: @entity_div_alert_recipient.mobile_number, recipient_name: @entity_div_alert_recipient.recipient_name, user_id: @entity_div_alert_recipient.user_id } }
    assert_redirected_to entity_div_alert_recipient_url(@entity_div_alert_recipient)
  end

  test "should destroy entity_div_alert_recipient" do
    assert_difference('EntityDivAlertRecipient.count', -1) do
      delete entity_div_alert_recipient_url(@entity_div_alert_recipient)
    end

    assert_redirected_to entity_div_alert_recipients_url
  end
end
