require "application_system_test_case"

class ActivityTypeMediaTest < ApplicationSystemTestCase
  setup do
    @activity_type_medium = activity_type_media(:one)
  end

  test "visiting the index" do
    visit activity_type_media_url
    assert_selector "h1", text: "Activity Type Media"
  end

  test "creating a Activity type medium" do
    visit activity_type_media_url
    click_on "New Activity Type Medium"

    check "Active status" if @activity_type_medium.active_status
    fill_in "Activity type code", with: @activity_type_medium.activity_type_code
    fill_in "Comment", with: @activity_type_medium.comment
    check "Del status" if @activity_type_medium.del_status
    fill_in "Media data", with: @activity_type_medium.media_data
    fill_in "Media path", with: @activity_type_medium.media_path
    fill_in "Media type", with: @activity_type_medium.media_type
    fill_in "User", with: @activity_type_medium.user_id
    click_on "Create Activity type medium"

    assert_text "Activity type medium was successfully created"
    click_on "Back"
  end

  test "updating a Activity type medium" do
    visit activity_type_media_url
    click_on "Edit", match: :first

    check "Active status" if @activity_type_medium.active_status
    fill_in "Activity type code", with: @activity_type_medium.activity_type_code
    fill_in "Comment", with: @activity_type_medium.comment
    check "Del status" if @activity_type_medium.del_status
    fill_in "Media data", with: @activity_type_medium.media_data
    fill_in "Media path", with: @activity_type_medium.media_path
    fill_in "Media type", with: @activity_type_medium.media_type
    fill_in "User", with: @activity_type_medium.user_id
    click_on "Update Activity type medium"

    assert_text "Activity type medium was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity type medium" do
    visit activity_type_media_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity type medium was successfully destroyed"
  end
end
