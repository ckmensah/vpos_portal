require "application_system_test_case"

class EntityInfoExtrasTest < ApplicationSystemTestCase
  setup do
    @entity_info_extra = entity_info_extras(:one)
  end

  test "visiting the index" do
    visit entity_info_extras_url
    assert_selector "h1", text: "Entity Info Extras"
  end

  test "creating a Entity info extra" do
    visit entity_info_extras_url
    click_on "New Entity Info Extra"

    check "Active status" if @entity_info_extra.active_status
    fill_in "Comment", with: @entity_info_extra.comment
    fill_in "Contact email", with: @entity_info_extra.contact_email
    fill_in "Contact number", with: @entity_info_extra.contact_number
    check "Del status" if @entity_info_extra.del_status
    fill_in "Entity code", with: @entity_info_extra.entity_code
    fill_in "Location address", with: @entity_info_extra.location_address
    fill_in "Postal address", with: @entity_info_extra.postal_address
    fill_in "User", with: @entity_info_extra.user_id
    fill_in "Web url", with: @entity_info_extra.web_url
    click_on "Create Entity info extra"

    assert_text "Entity info extra was successfully created"
    click_on "Back"
  end

  test "updating a Entity info extra" do
    visit entity_info_extras_url
    click_on "Edit", match: :first

    check "Active status" if @entity_info_extra.active_status
    fill_in "Comment", with: @entity_info_extra.comment
    fill_in "Contact email", with: @entity_info_extra.contact_email
    fill_in "Contact number", with: @entity_info_extra.contact_number
    check "Del status" if @entity_info_extra.del_status
    fill_in "Entity code", with: @entity_info_extra.entity_code
    fill_in "Location address", with: @entity_info_extra.location_address
    fill_in "Postal address", with: @entity_info_extra.postal_address
    fill_in "User", with: @entity_info_extra.user_id
    fill_in "Web url", with: @entity_info_extra.web_url
    click_on "Update Entity info extra"

    assert_text "Entity info extra was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity info extra" do
    visit entity_info_extras_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity info extra was successfully destroyed"
  end
end
