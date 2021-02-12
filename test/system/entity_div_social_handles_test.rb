require "application_system_test_case"

class EntityDivSocialHandlesTest < ApplicationSystemTestCase
  setup do
    @entity_div_social_handle = entity_div_social_handles(:one)
  end

  test "visiting the index" do
    visit entity_div_social_handles_url
    assert_selector "h1", text: "Entity Div Social Handles"
  end

  test "creating a Entity div social handle" do
    visit entity_div_social_handles_url
    click_on "New Entity Div Social Handle"

    check "Active status" if @entity_div_social_handle.active_status
    fill_in "Assigned code", with: @entity_div_social_handle.assigned_code
    check "Del status" if @entity_div_social_handle.del_status
    fill_in "Entity div code", with: @entity_div_social_handle.entity_div_code
    fill_in "Handle", with: @entity_div_social_handle.handle
    fill_in "User", with: @entity_div_social_handle.user_id
    click_on "Create Entity div social handle"

    assert_text "Entity div social handle was successfully created"
    click_on "Back"
  end

  test "updating a Entity div social handle" do
    visit entity_div_social_handles_url
    click_on "Edit", match: :first

    check "Active status" if @entity_div_social_handle.active_status
    fill_in "Assigned code", with: @entity_div_social_handle.assigned_code
    check "Del status" if @entity_div_social_handle.del_status
    fill_in "Entity div code", with: @entity_div_social_handle.entity_div_code
    fill_in "Handle", with: @entity_div_social_handle.handle
    fill_in "User", with: @entity_div_social_handle.user_id
    click_on "Update Entity div social handle"

    assert_text "Entity div social handle was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity div social handle" do
    visit entity_div_social_handles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity div social handle was successfully destroyed"
  end
end
