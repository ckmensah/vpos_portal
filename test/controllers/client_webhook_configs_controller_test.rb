require "test_helper"

class ClientWebhookConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client_webhook_config = client_webhook_configs(:one)
  end

  test "should get index" do
    get client_webhook_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_client_webhook_config_url
    assert_response :success
  end

  test "should create client_webhook_config" do
    assert_difference("ClientWebhookConfig.count") do
      post client_webhook_configs_url, params: { client_webhook_config: { active_status: @client_webhook_config.active_status, del_status: @client_webhook_config.del_status, entity_div_code: @client_webhook_config.entity_div_code, trans_type: @client_webhook_config.trans_type, url: @client_webhook_config.url, user_id: @client_webhook_config.user_id } }
    end

    assert_redirected_to client_webhook_config_url(ClientWebhookConfig.last)
  end

  test "should show client_webhook_config" do
    get client_webhook_config_url(@client_webhook_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_webhook_config_url(@client_webhook_config)
    assert_response :success
  end

  test "should update client_webhook_config" do
    patch client_webhook_config_url(@client_webhook_config), params: { client_webhook_config: { active_status: @client_webhook_config.active_status, del_status: @client_webhook_config.del_status, entity_div_code: @client_webhook_config.entity_div_code, trans_type: @client_webhook_config.trans_type, url: @client_webhook_config.url, user_id: @client_webhook_config.user_id } }
    assert_redirected_to client_webhook_config_url(@client_webhook_config)
  end

  test "should destroy client_webhook_config" do
    assert_difference("ClientWebhookConfig.count", -1) do
      delete client_webhook_config_url(@client_webhook_config)
    end

    assert_redirected_to client_webhook_configs_url
  end
end
