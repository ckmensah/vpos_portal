require "application_system_test_case"

class EntityDivisionsTest < ApplicationSystemTestCase
  setup do
    @entity_division = entity_divisions(:one)
  end

  test "visiting the index" do
    visit entity_divisions_url
    assert_selector "h1", text: "Entity Divisions"
  end

  test "creating a Entity division" do
    visit entity_divisions_url
    click_on "New Entity Division"

    check "Active status" if @entity_division.active_status
    fill_in "Activity code", with: @entity_division.activity_code
    fill_in "Assigned code", with: @entity_division.assigned_code
    fill_in "Comment", with: @entity_division.comment
    check "Del status" if @entity_division.del_status
    fill_in "Division name", with: @entity_division.division_name
    fill_in "Entity code", with: @entity_division.entity_code
    fill_in "Service label", with: @entity_division.service_label
    fill_in "Suburb", with: @entity_division.suburb_id
    fill_in "User", with: @entity_division.user_id
    click_on "Create Entity division"

    assert_text "Entity division was successfully created"
    click_on "Back"
  end

  test "updating a Entity division" do
    visit entity_divisions_url
    click_on "Edit", match: :first

    check "Active status" if @entity_division.active_status
    fill_in "Activity code", with: @entity_division.activity_code
    fill_in "Assigned code", with: @entity_division.assigned_code
    fill_in "Comment", with: @entity_division.comment
    check "Del status" if @entity_division.del_status
    fill_in "Division name", with: @entity_division.division_name
    fill_in "Entity code", with: @entity_division.entity_code
    fill_in "Service label", with: @entity_division.service_label
    fill_in "Suburb", with: @entity_division.suburb_id
    fill_in "User", with: @entity_division.user_id
    click_on "Update Entity division"

    assert_text "Entity division was successfully updated"
    click_on "Back"
  end

  test "destroying a Entity division" do
    visit entity_divisions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Entity division was successfully destroyed"
  end
end
