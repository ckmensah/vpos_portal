require "application_system_test_case"

class RegionMastersTest < ApplicationSystemTestCase
  setup do
    @region_master = region_masters(:one)
  end

  test "visiting the index" do
    visit region_masters_url
    assert_selector "h1", text: "Region Masters"
  end

  test "creating a Region master" do
    visit region_masters_url
    click_on "New Region Master"

    check "Active status" if @region_master.active_status
    fill_in "Comment", with: @region_master.comment
    check "Del status" if @region_master.del_status
    fill_in "Region name", with: @region_master.region_name
    fill_in "User", with: @region_master.user_id
    click_on "Create Region master"

    assert_text "Region master was successfully created"
    click_on "Back"
  end

  test "updating a Region master" do
    visit region_masters_url
    click_on "Edit", match: :first

    check "Active status" if @region_master.active_status
    fill_in "Comment", with: @region_master.comment
    check "Del status" if @region_master.del_status
    fill_in "Region name", with: @region_master.region_name
    fill_in "User", with: @region_master.user_id
    click_on "Update Region master"

    assert_text "Region master was successfully updated"
    click_on "Back"
  end

  test "destroying a Region master" do
    visit region_masters_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Region master was successfully destroyed"
  end
end
