require "application_system_test_case"

class EntityInfosTest < ApplicationSystemTestCase
  setup do
    @entity_info = entity_infos(:one)
  end

  test "visiting the index" do
    visit entity_infos_url
    assert_selector "h1", text: "Entity Infos"
  end

  test "creating a Entity info" do
    visit entity_infos_url
    click_on "New Entity Info"

    check "Active status" if @entity_info.active_status
    fill_in "Assigned code", with: @entity_info.assigned_code
    fill_in "Comment", with: @entity_info.comment
    check "Del status" if @entity_info.del_status
    fill_in "Entity alias", with: @entity_info.entity_alias
    fill_in "Entity cat", with: @entity_info.entity_cat_id
    fill_in "Entity name", with: @entity_info.entity_name
    fill_in "User", with: @entity_info.user_id
    click_on "Create Entity info"

    assert_text "Entity info was successfully created"
    click_on "Back"
  end

  test "updating a Entity info" do
    visit entity_infos_url
    click_on "Edit", match: :first

    check "Active status" if @entity_info.active_status
    fill_in "Assigned code", with: @entity_info.assigned_code
    fill_in "Comment", with: @entity_info.comment
    check "Del status" if @entity_info.del_status
    fill_in "Entity alias", with: @entity_info.entity_alias
    fill_in "Entity cat", with: @entity_info.entity_cat_id
    fill_in "Entity name", with: @entity_info.entity_name
    fill_in "User", with: @entity_info.user_id
    click_on "Update Entity info"

    assert_text "Entity info was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity info" do
    visit entity_infos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity info was successfully destroyed"
  end
end
