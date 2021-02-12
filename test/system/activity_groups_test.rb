require "application_system_test_case"

class ActivityGroupsTest < ApplicationSystemTestCase
  setup do
    @activity_group = activity_groups(:one)
  end

  test "visiting the index" do
    visit activity_groups_url
    assert_selector "h1", text: "Activity Groups"
  end

  test "creating a Activity group" do
    visit activity_groups_url
    click_on "New Activity Group"

    check "Active status" if @activity_group.active_status
    fill_in "Activity group desc", with: @activity_group.activity_group_desc
    fill_in "Assigned code", with: @activity_group.assigned_code
    check "Del status" if @activity_group.del_status
    fill_in "User", with: @activity_group.user_id
    click_on "Create Activity group"

    assert_text "Activity group was successfully created"
    click_on "Back"
  end

  test "updating a Activity group" do
    visit activity_groups_url
    click_on "Edit", match: :first

    check "Active status" if @activity_group.active_status
    fill_in "Activity group desc", with: @activity_group.activity_group_desc
    fill_in "Assigned code", with: @activity_group.assigned_code
    check "Del status" if @activity_group.del_status
    fill_in "User", with: @activity_group.user_id
    click_on "Update Activity group"

    assert_text "Activity group was successfully updated"
    click_on "Back"
  end

  test "destroying a Activity group" do
    visit activity_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Activity group was successfully destroyed"
  end
end
