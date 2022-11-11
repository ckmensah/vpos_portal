require "application_system_test_case"

class ClientWebhookConfigsTest < ApplicationSystemTestCase
  setup do
    @client_webhook_config = client_webhook_configs(:one)
  end

  test "visiting the index" do
    visit client_webhook_configs_url
    assert_selector "h1", text: "Client webhook configs"
  end

  test "should create client webhook config" do
    visit client_webhook_configs_url
    click_on "New client webhook config"

    check "Active status" if @client_webhook_config.active_status
    check "Del status" if @client_webhook_config.del_status
    fill_in "Entity div code", with: @client_webhook_config.entity_div_code
    fill_in "Trans type", with: @client_webhook_config.trans_type
    fill_in "Url", with: @client_webhook_config.url
    fill_in "User", with: @client_webhook_config.user_id
    click_on "Create Client webhook config"

    assert_text "Client webhook config was successfully created"
    click_on "Back"
  end

  test "should update Client webhook config" do
    visit client_webhook_config_url(@client_webhook_config)
    click_on "Edit this client webhook config", match: :first

    check "Active status" if @client_webhook_config.active_status
    check "Del status" if @client_webhook_config.del_status
    fill_in "Entity div code", with: @client_webhook_config.entity_div_code
    fill_in "Trans type", with: @client_webhook_config.trans_type
    fill_in "Url", with: @client_webhook_config.url
    fill_in "User", with: @client_webhook_config.user_id
    click_on "Update Client webhook config"

    assert_text "Client webhook config was successfully updated"
    click_on "Back"
  end

  test "should destroy Client webhook config" do
    visit client_webhook_config_url(@client_webhook_config)
    click_on "Destroy this client webhook config", match: :first

    assert_text "Client webhook config was successfully destroyed"
  end
end
