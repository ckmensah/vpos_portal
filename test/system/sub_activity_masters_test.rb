require "application_system_test_case"

class SubActivityMastersTest < ApplicationSystemTestCase
  setup do
    @sub_activity_master = sub_activity_masters(:one)
  end

  test "visiting the index" do
    visit sub_activity_masters_url
    assert_selector "h1", text: "Sub Activity Masters"
  end

  test "creating a Sub activity master" do
    visit sub_activity_masters_url
    click_on "New Sub Activity Master"

    check "Active status" if @sub_activity_master.active_status
    fill_in "Activity desc", with: @sub_activity_master.activity_desc
    fill_in "Assigned code", with: @sub_activity_master.assigned_code
    check "Del status" if @sub_activity_master.del_status
    fill_in "User", with: @sub_activity_master.user_id
    click_on "Create Sub activity master"

    assert_text "Sub activity master was successfully created"
    click_on "Back"
  end

  test "updating a Sub activity master" do
    visit sub_activity_masters_url
    click_on "Edit", match: :first

    check "Active status" if @sub_activity_master.active_status
    fill_in "Activity desc", with: @sub_activity_master.activity_desc
    fill_in "Assigned code", with: @sub_activity_master.assigned_code
    check "Del status" if @sub_activity_master.del_status
    fill_in "User", with: @sub_activity_master.user_id
    click_on "Update Sub activity master"

    assert_text "Sub activity master was successfully updated"
    click_on "Back"
  end

  test "destroying a Sub activity master" do
    visit sub_activity_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sub activity master was successfully destroyed"
  end
end
