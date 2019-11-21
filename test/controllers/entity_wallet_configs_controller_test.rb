require 'test_helper'

class EntityWalletConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @entity_wallet_config = entity_wallet_configs(:one)
  end

  test "should get index" do
    get entity_wallet_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_entity_wallet_config_url
    assert_response :success
  end

  test "should create entity_wallet_config" do
    assert_difference('EntityWalletConfig.count') do
      post entity_wallet_configs_url, params: { entity_wallet_config: { active_status: @entity_wallet_config.active_status, client_key: @entity_wallet_config.client_key, comment: @entity_wallet_config.comment, del_status: @entity_wallet_config.del_status, division_code: @entity_wallet_config.division_code, secret_key: @entity_wallet_config.secret_key, service_id: @entity_wallet_config.service_id, user_id: @entity_wallet_config.user_id } }
    end

    assert_redirected_to entity_wallet_config_url(EntityWalletConfig.last)
  end

  test "should show entity_wallet_config" do
    get entity_wallet_config_url(@entity_wallet_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_entity_wallet_config_url(@entity_wallet_config)
    assert_response :success
  end

  test "should update entity_wallet_config" do
    patch entity_wallet_config_url(@entity_wallet_config), params: { entity_wallet_config: { active_status: @entity_wallet_config.active_status, client_key: @entity_wallet_config.client_key, comment: @entity_wallet_config.comment, del_status: @entity_wallet_config.del_status, division_code: @entity_wallet_config.division_code, secret_key: @entity_wallet_config.secret_key, service_id: @entity_wallet_config.service_id, user_id: @entity_wallet_config.user_id } }
    assert_redirected_to entity_wallet_config_url(@entity_wallet_config)
  end

  test "should destroy entity_wallet_config" do
    assert_difference('EntityWalletConfig.count', -1) do
      delete entity_wallet_config_url(@entity_wallet_config)
    end

    assert_redirected_to entity_wallet_configs_url
  end
end
