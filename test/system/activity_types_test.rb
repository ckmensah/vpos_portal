require "application_system_test_case"

class ActivityTypesTest < ApplicationSystemTestCase
  setup do
    @activity_type = activity_types(:one)
  end

  test "visiting the index" do
    visit activity_types_url
    assert_selector "h1", text: "Activity Types"
  end

  test "creating a Activity type" do
    visit activity_types_url
    click_on "New Activity Type"

    check "Active status" if @activity_type.active_status
    fill_in "Assigned code", with: @activity_type.assigned_code
    fill_in "Comment", with: @activity_type.comment
    check "Del status" if @activity_type.del_status
    fill_in "Type desc", with: @activity_type.type_desc
    fill_in "User", with: @activity_type.user_id
    click_on "Create Activity type"

    assert_text "Activity type was successfully created"
    click_on "Back"
  end

  test "updating a Activity type" do
    visit activity_types_url
    click_on "Edit", match: :first

    check "Active status" if @activity_type.active_status
    fill_in "Assigned code", with: @activity_type.assigned_code
    fill_in "Comment", with: @activity_type.comment
    check "Del status" if @activity_type.del_status
    fill_in "Type desc", with: @activity_type.type_desc
    fill_in "User", with: @activity_type.user_id
    click_on "Update Activity type"

    assert_text "Activity type was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity type" do
    visit activity_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity type was successfully destroyed"
  end
end
