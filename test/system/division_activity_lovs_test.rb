require "application_system_test_case"

class DivisionActivityLovsTest < ApplicationSystemTestCase
  setup do
    @division_activity_lov = division_activity_lovs(:one)
  end

  test "visiting the index" do
    visit division_activity_lovs_url
    assert_selector "h1", text: "Division Activity Lovs"
  end

  test "creating a Division activity lov" do
    visit division_activity_lovs_url
    click_on "New Division Activity Lov"

    check "Active status" if @division_activity_lov.active_status
    fill_in "Activity code", with: @division_activity_lov.activity_code
    fill_in "Comment", with: @division_activity_lov.comment
    check "Del status" if @division_activity_lov.del_status
    fill_in "Division code", with: @division_activity_lov.division_code
    fill_in "Lov desc", with: @division_activity_lov.lov_desc
    fill_in "User", with: @division_activity_lov.user_id
    click_on "Create Division activity lov"

    assert_text "Division activity lov was successfully created"
    click_on "Back"
  end

  test "updating a Division activity lov" do
    visit division_activity_lovs_url
    click_on "Edit", match: :first

    check "Active status" if @division_activity_lov.active_status
    fill_in "Activity code", with: @division_activity_lov.activity_code
    fill_in "Comment", with: @division_activity_lov.comment
    check "Del status" if @division_activity_lov.del_status
    fill_in "Division code", with: @division_activity_lov.division_code
    fill_in "Lov desc", with: @division_activity_lov.lov_desc
    fill_in "User", with: @division_activity_lov.user_id
    click_on "Update Division activity lov"

    assert_text "Division activity lov was successfully updated"
    click_on "Back"
  end

  test "destroying a Division activity lov" do
    visit division_activity_lovs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Division activity lov was successfully destroyed"
  end
end
