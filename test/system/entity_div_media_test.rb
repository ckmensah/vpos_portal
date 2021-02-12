require "application_system_test_case"

class EntityDivMediaTest < ApplicationSystemTestCase
  setup do
    @entity_div_medium = entity_div_media(:one)
  end

  test "visiting the index" do
    visit entity_div_media_url
    assert_selector "h1", text: "Entity Div Media"
  end

  test "creating a Entity div medium" do
    visit entity_div_media_url
    click_on "New Entity Div Medium"

    check "Active status" if @entity_div_medium.active_status
    check "Del status" if @entity_div_medium.del_status
    fill_in "Entity div code", with: @entity_div_medium.entity_div_code
    fill_in "Media data", with: @entity_div_medium.media_data
    fill_in "Media path", with: @entity_div_medium.media_path
    fill_in "Media type", with: @entity_div_medium.media_type
    fill_in "User", with: @entity_div_medium.user_id
    click_on "Create Entity div medium"

    assert_text "Entity div medium was successfully created"
    click_on "Back"
  end

  test "updating a Entity div medium" do
    visit entity_div_media_url
    click_on "Edit", match: :first

    check "Active status" if @entity_div_medium.active_status
    check "Del status" if @entity_div_medium.del_status
    fill_in "Entity div code", with: @entity_div_medium.entity_div_code
    fill_in "Media data", with: @entity_div_medium.media_data
    fill_in "Media path", with: @entity_div_medium.media_path
    fill_in "Media type", with: @entity_div_medium.media_type
    fill_in "User", with: @entity_div_medium.user_id
    click_on "Update Entity div medium"

    assert_text "Entity div medium was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity div medium" do
    visit entity_div_media_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity div medium was successfully destroyed"
  end
end
