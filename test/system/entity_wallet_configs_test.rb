require "application_system_test_case"

class EntityWalletConfigsTest < ApplicationSystemTestCase
  setup do
    @entity_wallet_config = entity_wallet_configs(:one)
  end

  test "visiting the index" do
    visit entity_wallet_configs_url
    assert_selector "h1", text: "Entity Wallet Configs"
  end

  test "creating a Entity wallet config" do
    visit entity_wallet_configs_url
    click_on "New Entity Wallet Config"

    check "Active status" if @entity_wallet_config.active_status
    fill_in "Client key", with: @entity_wallet_config.client_key
    fill_in "Comment", with: @entity_wallet_config.comment
    check "Del status" if @entity_wallet_config.del_status
    fill_in "Division code", with: @entity_wallet_config.division_code
    fill_in "Secret key", with: @entity_wallet_config.secret_key
    fill_in "Service", with: @entity_wallet_config.service_id
    fill_in "User", with: @entity_wallet_config.user_id
    click_on "Create Entity wallet config"

    assert_text "Entity wallet config was successfully created"
    click_on "Back"
  end

  test "updating a Entity wallet config" do
    visit entity_wallet_configs_url
    click_on "Edit", match: :first

    check "Active status" if @entity_wallet_config.active_status
    fill_in "Client key", with: @entity_wallet_config.client_key
    fill_in "Comment", with: @entity_wallet_config.comment
    check "Del status" if @entity_wallet_config.del_status
    fill_in "Division code", with: @entity_wallet_config.division_code
    fill_in "Secret key", with: @entity_wallet_config.secret_key
    fill_in "Service", with: @entity_wallet_config.service_id
    fill_in "User", with: @entity_wallet_config.user_id
    click_on "Update Entity wallet config"

    assert_text "Entity wallet config was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity wallet config" do
    visit entity_wallet_configs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity wallet config was successfully destroyed"
  end
end
