require "application_system_test_case"

class EntityAdminWhitelistsTest < ApplicationSystemTestCase
  setup do
    @entity_admin_whitelist = entity_admin_whitelists(:one)
  end

  test "visiting the index" do
    visit entity_admin_whitelists_url
    assert_selector "h1", text: "Entity Admin Whitelists"
  end

  test "creating a Entity admin whitelist" do
    visit entity_admin_whitelists_url
    click_on "New Entity Admin Whitelist"

    check "Active status" if @entity_admin_whitelist.active_status
    check "Del status" if @entity_admin_whitelist.del_status
    fill_in "Entity division code", with: @entity_admin_whitelist.entity_division_code
    fill_in "Full name", with: @entity_admin_whitelist.full_name
    fill_in "Mobile number", with: @entity_admin_whitelist.mobile_number
    fill_in "User", with: @entity_admin_whitelist.user_id
    click_on "Create Entity admin whitelist"

    assert_text "Entity admin whitelist was successfully created"
    click_on "Back"
  end

  test "updating a Entity admin whitelist" do
    visit entity_admin_whitelists_url
    click_on "Edit", match: :first

    check "Active status" if @entity_admin_whitelist.active_status
    check "Del status" if @entity_admin_whitelist.del_status
    fill_in "Entity division code", with: @entity_admin_whitelist.entity_division_code
    fill_in "Full name", with: @entity_admin_whitelist.full_name
    fill_in "Mobile number", with: @entity_admin_whitelist.mobile_number
    fill_in "User", with: @entity_admin_whitelist.user_id
    click_on "Update Entity admin whitelist"

    assert_text "Entity admin whitelist was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity admin whitelist" do
    visit entity_admin_whitelists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity admin whitelist was successfully destroyed"
  end
end
